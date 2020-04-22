#!/bin/bash
## Commands for Ubuntu Server 18.04 LTS (HVM), SSD Volume Type
## These script will install the following components:
## Microkubernetes 1.15, Keptn 6.1 with Istio 1.5 and Helm 1.2, the OneAgent and an ActiveGate

## ----  Define variables ----
# Write the installation in logfile
LOGFILE='/tmp/install.log'
chmod 775 $LOGFILE

# Define Dynatrace Environment
# Sample: https://{your-domain}/e/{your-environment-id} for managed or https://{your-environment-id}.live.dynatrace.com for SaaS
TENANT=
PAASTOKEN=
APITOKEN=

# Set installation modules
verbose_mode=false
update_ubuntu=true
docker_install=true
microk8s_install=true
setup_proaliases=true
setup_magicdomain=true
enable_k8dashboard=true
enable_registry=true
dynatrace_activegate_install=true
istio_install=true
helm_install=true
keptn_install=true
certmanager_install=false

resources_clone=true
keptn_examples_clone=true

dynatrace_savecredentials=true
keptndemo_teaser_pipeline=true
resources_route_istio_ingress=true


keptndemo_cartsload=true


## ----  Write all to the logfile ----
# Saves file descriptors so they can be restored to whatever they were before redirection or used 
# themselves to output to whatever they were before the following redirect.
exec 3>&1 4>&2
# Restore file descriptors for particular signals. Not generally necessary since they should be restored when the sub-shell exits.
trap 'exec 2>&4 1>&3' 0 1 2 3
# Redirect stdout to file log.out then redirect stderr to stdout. Note that the order is important when you 
# want them going to the same file. stdout must be redirected before stderr is redirected to stdout.
exec 1>$LOGFILE 2>&1

# Record Log duration
SECONDS=0

echo ""
echo "***** Init Installation at  `date` by user `whoami` ****"
echo "***** Setting up Microk8s (SingleNode K8s Dev Cluster) with Keptn ****"
echo ""

# Util functions
timestamp() {
  date +"[%Y-%m-%d %H:%M:%S]"
}

printInfo() {
  echo "[Keptn-In-A-Box|INFO] $(timestamp) $1"
}

printError() {
  echo "[Keptn-In-A-Box|ERROR] $(timestamp) $1"
}

waitForAllPods(){
    RETRY=0; 
    RETRY_MAX=24; 
    # Get all pods, count and invert the search for not running nor completed. Status is for deleting the last line of the output
    CMD="sudo -H -u ubuntu bash -c \"kubectl get pods -A 2>&1 | grep -c -v -E '(Running|Completed|Terminating|STATUS)'\""
    printInfo "Checking and wait for all pods to run."
    while [[ $RETRY -lt $RETRY_MAX ]]; do
      pods_not_ok=$(eval "$CMD")
      if [[ "$pods_not_ok" == '0' ]]; then
      printInfo "All pods are running."
      break
      fi
      RETRY=$[$RETRY+1]
      printInfo "Retry: ${RETRY}/${RETRY_MAX} - Wait 10s for $pods_not_ok PoDs to finish or be in state Running ... "
      sleep 10
    done

    if [[ $RETRY == $RETRY_MAX ]]; then
      printError "Pods in namespace ${NAMESPACE} are not running. Exiting installation..."
      # show the pods that have problems
      sudo -H -u ubuntu bash -c "kubectl get pods --field-selector=status.phase!=Running -A"
      exit 1
    fi
}

enableVerbose(){
    if [ "$verbose_mode" = true ] ; then
      log "Activating verbose mode"
      set -x
    fi
}

# Installation functions
updateUbuntu(){
    if [ "$update_ubuntu" = true ] ; then
      printInfo "Updating Ubuntu"
      apt update
    fi
}

dynatracePrintCredentials(){
    printInfo "Shuffle the variables for name convention with Keptn & Dynatrace"
    PROTOCOL="https://"
    DT_TENANT=${TENANT#"$PROTOCOL"}
    printInfo "Cleaned tenant=$DT_TENANT" 
    DT_API_TOKEN=$APITOKEN
    DT_PAAS_TOKEN=$PAASTOKEN
    printInfo ""
    printInfo "Dynatrace Tenant: $DT_TENANT"
    printInfo "Dynatrace API Token: $DT_API_TOKEN"
    printInfo "Dynatrace PaaS Token: $DT_PAAS_TOKEN"
}

dockerInstall(){
    if [ "$docker_install" = true ] ; then
      printInfo "***** Install Docker *****"
      apt install docker.io -y  
      service docker start
      usermod -a -G docker ubuntu
    fi
}


microk8sInstall(){
    if [ "$microk8s_install" = true ] ; then
    printInfo "*** Installing Microkubernetes with Kubernetes Version 1.15 ***"
    snap install microk8s --channel=1.15/stable --classic
    
    printInfo "allowing the execution of priviledge pods "
    bash -c "echo \"--allow-privileged=true\" >> /var/snap/microk8s/current/args/kube-apiserver"
    
    printInfo " - Add ubuntu to microk8 usergroup *** "
    usermod -a -G microk8s ubuntu

    printInfo " - Update IPTABLES, allow traffic for pods (internal and external) "
    iptables -P FORWARD ACCEPT
    ufw allow in on cni0 && sudo ufw allow out on cni0
    ufw default allow routed 

    printInfo " - Add alias to Kubectl (Bash completion for kubectl is already enabled in microk8s)"
    snap alias microk8s.kubectl kubectl 

    printInfo " - Add Snap to the system wide environment."
    sed -i 's~/usr/bin:~/usr/bin:/snap/bin:~g' /etc/environment
    fi
}

setupProAliases(){
    if [ "$setup_proaliases" = true ] ; then
      printInfo "*** Adding Bash and Kubectl Pro CLI aliases to .bash_aliases for user ubuntu and root *** "
      echo "
      # Alias for ease of use of the CLI
      alias hg='history | grep' 
      alias h='history' 
      alias vaml='vi -c \"set syntax:yaml\" -' 
      alias vson='vi -c \"set syntax:json\" -' 
      alias pg='ps -aux | grep' " > /root/.bash_aliases
      cp /root/.bash_aliases /home/ubuntu/.bash_aliases
    fi
}

microk8sStart(){
    printInfo "***** Starting Microk8s *****"
    sudo -H -u ubuntu bash -c 'microk8s.start'
}

microk8sEnableBasic(){
    printInfo "***** Enable DNS, Storage, NGINX Ingress *****"
    sudo -H -u ubuntu bash -c 'microk8s.enable dns storage ingress'
    waitForAllPods
}

microk8sEnableDashboard(){
    if [ "$enable_k8dashboard" = true ] ; then
      printInfo "***** Enable Kubernetes Dashboard *****"
      sudo -H -u ubuntu bash -c 'microk8s.enable dashboard'
      waitForAllPods
    fi
}

microk8sEnableRegistry(){
    if [ "$enable_registry" = true ] ; then
      printInfo "***** Enable own Docker Registry *****"
      sudo -H -u ubuntu bash -c 'microk8s.enable registry'
      waitForAllPods
    fi
}

dynatraceActiveGateInstall(){
    if [ "$dynatrace_activegate_install" = true ] ; then
      printInfo " ***** Installation of Active Gate ***** "
      wget -nv -O activegate.sh "https://$DT_TENANT/api/v1/deployment/installer/gateway/unix/latest?Api-Token=$DT_PAAS_TOKEN&arch=x86&flavor=default"
      sh activegate.sh 
    fi
}

istioInstall(){
    if [ "$istio_install" = true ] ; then
      printInfo " ***** Install istio 1.5 into /Opt and add it to user/local/bin ***** "
      curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.5.1 sh - 
      mv istio-1.5.1 /opt/istio-1.5.1 
      chmod +x -R /opt/istio-1.5.1/
      ln -s /opt/istio-1.5.1/bin/istioctl /usr/local/bin/istioctl
      sudo -H -u ubuntu bash -c "echo 'y' | istioctl manifest apply"
      waitForAllPods
    fi
}

helmInstall(){
    if [ "$helm_install" = true ] ; then
      printInfo " *****  Installing HELM Client v2.12.3 ***** "
      wget -O getHelm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get
      chmod +x getHelm.sh
      ./getHelm.sh -v v2.12.3
      helm init 
    fi
}

keptnInstall(){
    if [ "$keptn_install" = true ] ; then
      printInfo " ***** Install KEPTN 0.6.1 **** "
      wget -q -O keptn.tar https://github.com/keptn/keptn/releases/download/0.6.1/0.6.1_keptn-linux.tar
      tar -xvf keptn.tar
      chmod +x keptn 
      mv keptn /usr/local/bin/keptn
    fi
}

certmanagerInstall(){
    if [ "$certmanager_install" = true ] ; then
      printInfo " ***** Install CertManager ***** "
      sudo -H -u ubuntu bash -c 'kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.14.0/cert-manager.yaml'
      waitForAllPods
    fi
}

keptndemoDeployCartsloadgenerator(){
    # Code of the Loadgenerator found in
    # https://github.com/sergiohinojosa/keptn-in-a-box/resources/cartsloadgenerator
    if [ "$keptndemo_cartsload" = true ] ; then
      printInfo " ***** Deploy Cartsload Generator ***** "
      sudo -H -u ubuntu bash -c "kubectl create deploy cartsloadgen --image=shinojosa/cartsloadgen:keptn"
    fi
}

resourcesClone(){
    if [ "$resources_clone" = true ] ; then
      printInfo " ***** Clone Keptn-in-a-Box Resources ***** "
      sudo -H -u ubuntu bash -c "git clone https://github.com/sergiohinojosa/keptn-in-a-box /home/ubuntu/keptn-in-a-box"
    fi
}


keptnExamplesClone(){
    if [ "$keptn_examples_clone" = true ] ; then
      printInfo " ***** Clone Keptn Exmaples ***** "
      sudo -H -u ubuntu bash -c "git clone --branch 0.6.1 https://github.com/keptn/examples.git /home/ubuntu/examples --single-branch"
    fi
}

dynatraceSaveCredentials(){
    if [ "$dynatrace_savecredentials" = true ] ; then
      printInfo " ***** Save Dynatrace credentials ***** "
      sudo -H -u ubuntu bash -c "cd /home/ubuntu/keptn-in-a-box/resources/dynatrace/ ; bash save-credentials.sh \"$DT_TENANT\" \"$PAASTOKEN\" \"$APITOKEN\""
      sudo -H -u ubuntu bash -c "bash /home/ubuntu/keptn-in-a-box/resources/dynatrace/save-credentials.sh show"
    fi
}

keptndemoTeaserPipeline(){
    if [ "$keptndemo_teaser_pipeline" = true ] ; then
      printInfo " ***** Deploying the Autonomous Cloud (dynamic) Teaser with Pipeline overview  ***** "
      # Code of the Loadgenerator found in
      # https://github.com/sergiohinojosa/keptn-in-a-box/resources/homepage
      sudo -H -u ubuntu bash -c "kubectl -n istio-system create deploy nginx --image=shinojosa/nginxacm"
      sudo -H -u ubuntu bash -c "kubectl -n istio-system expose deploy nginx --port=80 --type=NodePort"
    fi
}

resourcesRouteIstioIngress(){
    if [ "$resources_route_istio_ingress" = true ] ; then
      printInfo " ***** Route Traffic to IstioGateway and Create SSL certificates for Istio Endpoints **** "
      sudo -H -u ubuntu bash -c "cd /home/ubuntu/keptn-in-a-box/resources/istio && bash expose-istio.sh \"$DOMAIN\""
    fi
}

stillToDo(){

    printf "\n\n*****  Create user 'dynatrace', we specify bash login, home directory, password and add him to the sudoers\n" >> $LOGFILE 2>&1 
    # Add user with password so SSH login with password is possible. Share same home directory
    # Add Dynatrace & Ubuntu to microk8s & docker
    usermod -a -G microk8s ubuntu
    usermod -a -G docker ubuntu
    # TODO - Enhance - paramatirize user and password with RTA CSV Variables
    useradd -s /bin/bash -d /home/ubuntu/ -m -G sudo -p $(openssl passwd -1 dynatrace) dynatrace
    # Share own groups with each other
    usermod -a -G ubuntu dynatrace
    usermod -a -G dynatrace ubuntu
    usermod -a -G microk8s dynatrace
    usermod -a -G docker dynatrace
    cp /root/.bash_aliases /home/dynatrace/.bash_aliases
    # Copy Aliases
    cp /root/.bash_aliases /home/ubuntu/.bash_aliases
    # Start Micro Enable Default Modules as Ubuntu
    # Passing the commands to ubuntu since it has microk8s in its path and also does not have password enabled otherwise the install will fail
    # Copy the Workshop from Github and unpack them
    git clone --branch 0.6.1 https://github.com/acm-workshops/keptn-workshop.git /home/ubuntu/keptn-workshop  --single-branch
    # TODO: Refactor - Dont clone this repo, KISS.
    # is this needed? I can add a subfolder and merge?
    git clone --branch 0.6.1 https://github.com/keptn/examples.git /home/ubuntu/examples --single-branch
    # Change owner of cloned folders
    chown ubuntu:ubuntu -R /home/ubuntu/

    # TODO
    {  printf "\n\n\n" ;\
   

    # TODO:  Enhacement - Validation CertManager is ready 

    # Getting the public DOMAIN
    export PUBLIC_IP=$(curl -s ifconfig.me) ;\
    PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g') ;\
    export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io" ;\
    printf "Public DNS: $DOMAIN"

    # TODO if SSL else normal (before if certmanager)
    printf "\n\n***** Route Traffic to IstioGateway and Create SSL certificates for Istio Endpoints ****\n"
    { sudo -H -u ubuntu bash -c "cd /home/ubuntu/keptn-workshop/setup/istio && sh expose-istio.sh \"$DOMAIN\"" ;} >> $LOGFILE 2>&1

    # Route expose K8 Services (if API and Dashboard) 
    {  printf "\n\n*****Allow access to K8 Dashboard withouth login ***** \n" ;\
    sudo -H -u ubuntu bash -c "cd /home/ubuntu/keptn-workshop/setup/k8-services && bash expose-k8-services.sh \"$DOMAIN\"" ;} >> $LOGFILE 2>&1


    {  printf "\n\n*****Configure Public Domain for Keptn on Microk8s  ***** \n" ;\
    sudo -H -u ubuntu bash -c "kubectl create configmap keptn-domain --from-literal=domain=$DOMAIN" ;} >> $LOGFILE 2>&1

    { printf "\n\n***** Install Keptn *****\n" ;\
    sudo -H -u ubuntu bash -c 'echo 'y' | keptn install --platform=kubernetes --istio-install-option=Reuse --gateway=LoadBalancer --keptn-installer-image=shinojosa/keptninstaller:6.1.customdomain' ;} >> $LOGFILE 2>&1

    # Authorize keptn
    printf "\nFor authorizing Keptn type:
    keptn auth --endpoint=https://api.keptn.$(kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain}) --api-token=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)\n"

    # Install OA
    { printf "\n\n***** Installing and configuring Dynatrace on the Cluster *****\n\n" ;\
    sudo -H -u ubuntu bash -c "kubectl -n keptn create secret generic dynatrace --from-literal=\"DT_TENANT=$DT_TENANT\" --from-literal=\"DT_API_TOKEN=$APITOKEN\"  --from-literal=\"DT_PAAS_TOKEN=$PAASTOKEN\"" ;\
    sudo -H -u ubuntu bash -c "kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-service/0.6.2/deploy/manifests/dynatrace-service/dynatrace-service.yaml" ;\
    sudo -H -u ubuntu bash -c "kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-sli-service/0.3.1/deploy/service.yaml" ;\
    printf "\n wait for Webhook to be available.. sleep 20 sec" ; sleep 20s ;\
    sudo -H -u ubuntu bash -c "keptn configure monitoring dynatrace" ;} >> $LOGFILE 2>&1

    # Expose bridge via VS
    { printf "\n\n*****  Expose Bridge via VS and update to EAP   *****\n\n" ;\
    sudo -H -u ubuntu bash -c "kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:20200326.0744 --record" ;\
    DOMAIN=$(sudo -H -u ubuntu bash -c "kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain}") ;\
    sudo -H -u ubuntu bash -c "cd /home/ubuntu/keptn-workshop/setup/expose-bridge && bash expose-bridge.sh \"$DOMAIN\"" ;}  >> $LOGFILE 2>&1

    # OnBoard Unleash
    { printf "\n\n*****  Deploy Unleash-Server  *****\n\n" ;\
    sudo -H -u ubuntu bash -c "cd /home/ubuntu/examples/unleash-server/ && bash /home/ubuntu/keptn-workshop/setup/deploy_unleashserver.sh" ;} >> $LOGFILE 2>&1

    # Configure Kubernetes Monitoring
    { printf "\n\n*****  Configure Kubernetes Monitoring  *****\n\n" ;\
    sudo -H -u ubuntu bash -c "cd /home/ubuntu/keptn-workshop/setup/dynatrace && bash configure-k8.sh" ;} >> $LOGFILE 2>&1

    { printf "\n\n*****Allow -rwx for the user and group (dynatrace) for all files in the home directory ***** \n" ;\
    chmod -R 774 /home/ubuntu/* ;} >> $LOGFILE 2>&1

    # Allow unencrypted password via SSH for login
    # Restart the SSHD Service
    { printf "\n\n***** Allow Password authentication and restarting SSH service *****\n" ;\
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config ;\
    service sshd restart ;} >> $LOGFILE 2>&1

    # Installation finish, print time.
    DURATION=$SECONDS
    printf "\n\n***** Installation complete :) *****\nIt took $(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds " >> $LOGFILE 2>&1

    #TODO Reset a keptn pod, for the pushing of events to work.
    # Log duration
    
    # Onboard Carts Application
    sudo -H -u ubuntu bash -c "cd /home/ubuntu/examples/onboarding-carts/ && bash /home/ubuntu/keptn-workshop/setup/onboard_carts.sh && bash /home/ubuntu/keptn-workshop/setup/deploy_carts_0.sh" >> $LOGFILE 2>&1


}

printInstalltime(){
     # Installation finish, print time.
    DURATION=$SECONDS
    printInfo "***** Installation complete :) *****\nIt took $(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds "
}


# Sequence of the functions for modular installation
enableVerbose
updateUbuntu
dynatracePrintCredentials
setupProAliases 
dockerInstall
microk8sInstall
microk8sStart
microk8sEnableBasic
microk8sEnableDashboard
microk8sEnableRegistry
dynatraceActiveGateInstall
istioInstall
helmInstall
certmanagerInstall
keptnInstall

resourcesClone
keptnExamplesClone

dynatraceSaveCredentials

keptndemoTeaserPipeline

resourcesRouteIstioIngress

cartsdemoDeployLoadgenerator
printInstalltime