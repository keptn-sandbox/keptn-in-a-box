#!/bin/bash

# This file contains the functions for installing Keptn-in-a-Box
# For the variables 6 version definitions do it in the keptn-in-a-box.sh file

#  Listing of all the installation modules
verbose_mode=false
update_ubuntu=false
docker_install=false
microk8s_install=false
setup_proaliases=false
enable_k8dashboard=false
enable_registry=false
istio_install=false
helm_install=false
certmanager_install=false
certmanager_enable=false
keptn_install=false
keptn_examples_clone=false
resources_clone=false
resources_route_istio_ingress=false
dynatrace_savecredentials=false
dynatrace_configure_monitoring=false
dynatrace_activegate_install=false
dynatrace_configure_workloads=false
keptn_bridge_expose=false
keptn_bridge_eap=false
keptndemo_teaser_pipeline=false
keptndemo_cartsload=false
keptndemo_unleash=false
keptndemo_cartsonboard=false
microk8s_expose_kubernetes_api=false
microk8s_expose_kubernetes_dashboard=false
create_workshop_user=false

installationModulesDefault(){
  # INSTALLATION MODULES
  update_ubuntu=true
  docker_install=true
  microk8s_install=true
  setup_proaliases=true

  enable_k8dashboard=true
  istio_install=true
  helm_install=true

  certmanager_install=false
  certmanager_enable=false

  keptn_install=true
  keptn_examples_clone=true
  resources_clone=true
  resources_route_istio_ingress=true
  dynatrace_savecredentials=true
  dynatrace_configure_monitoring=true
  dynatrace_activegate_install=true
  dynatrace_configure_workloads=true
  keptn_bridge_expose=true
  keptn_bridge_eap=true
  keptndemo_teaser_pipeline=true
  keptndemo_cartsload=true
  keptndemo_unleash=true
  keptndemo_cartsonboard=true
  microk8s_expose_kubernetes_api=true
  microk8s_expose_kubernetes_dashboard=true
  create_workshop_user=false
}

installationModulesFull(){
  # installation default
  installationModulesDefault
  
  enable_registry=true

  # plus all others 
  certmanager_install=true
  certmanager_enable=true
  create_workshop_user=true
}

installationModulesMinimal(){
  # The minimal to have a full keptn working 
  # with exposed istio and keptn over nginx 
  update_ubuntu=true
  docker_install=true
  microk8s_install=true
  setup_proaliases=true

  istio_install=true
  keptn_install=true
  resources_clone=true
  resources_route_istio_ingress=true
  keptn_bridge_expose=true
  microk8s_expose_kubernetes_api=true
  keptndemo_teaser_pipeline=true
}

setBashas(){
  # Wrapper for runnig commands for the real owner and not as root
  alias bashas="sudo -H -u ${USER} bash -c"
  # Expand aliases for non-interactive shell
  shopt -s expand_aliases
}

# FUNCTIONS DECLARATIONS
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
    CMD="bashas \"kubectl get pods -A 2>&1 | grep -c -v -E '(Running|Completed|Terminating|STATUS)'\""
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
      bashas "kubectl get pods --field-selector=status.phase!=Running -A"
      exit 1
    fi
}

enableVerbose(){
    if [ "$verbose_mode" = true ] ; then
      printInfo "Activating verbose mode"
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

dynatracePrintValidateCredentials(){
  printInfo " **** Printing Dynatrace Credentials ****"
  if [ -n "${TENANT}" ] ; then
    printInfo " **** Shuffle the variables for name convention with Keptn & Dynatrace ****"
    PROTOCOL="https://"
    DT_TENANT=${TENANT#"$PROTOCOL"}
    printInfo "Cleaned tenant=$DT_TENANT" 
    DT_API_TOKEN=$APITOKEN
    DT_PAAS_TOKEN=$PAASTOKEN
    printInfo ""
    printInfo "Dynatrace Tenant: $DT_TENANT"
    printInfo "Dynatrace API Token: $DT_API_TOKEN"
    printInfo "Dynatrace PaaS Token: $DT_PAAS_TOKEN"
  else
    printInfo " **** Dynatrace Variables not set, Dynatrace wont be installed****"
    dynatrace_savecredentials=false
    dynatrace_configure_monitoring=false
    dynatrace_activegate_install=false
    dynatrace_configure_workloads=false
  fi
}

dockerInstall(){
    if [ "$docker_install" = true ] ; then
      printInfo "***** Install J Query *****"
      apt install jq -y 
      printInfo "***** Install Docker *****"
      apt install docker.io -y  
      service docker start
      usermod -a -G docker $USER
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
      homedir=$(eval echo ~$USER)
      cp /root/.bash_aliases $homedir/.bash_aliases
    fi
}

setupMagicDomainPublicIp(){
    if [ -n "${DOMAIN}" ] ; then
      printInfo " ***** The following domain is defined: $DOMAIN ***** "
      export DOMAIN
    else
      printInfo " ***** No DOMAIN is defined, converting the public IP in a magic nip.io domain ***** "
      PUBLIC_IP=$(curl -s ifconfig.me) 
      PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
      export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io" 
      printInfo "Magic Domain: $DOMAIN"
    fi
}

microk8sInstall(){
    if [ "$microk8s_install" = true ] ; then
    printInfo "*** Installing Microkubernetes with Kubernetes Version 1.15 ***"
    snap install microk8s --channel=$MICROK8S_CHANNEL --classic
    
    printInfo "allowing the execution of priviledge pods "
    bash -c "echo \"--allow-privileged=true\" >> /var/snap/microk8s/current/args/kube-apiserver"
    
    printInfo " - Add ubuntu to microk8 usergroup *** "
    usermod -a -G microk8s $USER

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

microk8sStart(){
    printInfo "***** Starting Microk8s *****"
    bashas 'microk8s.start'
}

microk8sEnableBasic(){
    printInfo "***** Enable DNS, Storage, NGINX Ingress *****"
    bashas 'microk8s.enable dns storage ingress'
    waitForAllPods
}

microk8sEnableDashboard(){
    if [ "$enable_k8dashboard" = true ] ; then
      printInfo "***** Enable Kubernetes Dashboard *****"
      bashas 'microk8s.enable dashboard'
      waitForAllPods
    fi
}

microk8sEnableRegistry(){
    if [ "$enable_registry" = true ] ; then
      printInfo "***** Enable own Docker Registry *****"
      bashas 'microk8s.enable registry'
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
      printInfo " ***** Install istio $ISTIO_VERSION into /Opt and add it to user/local/bin ***** "
      curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh - 
      mv istio-$ISTIO_VERSION /opt/istio-$ISTIO_VERSION 
      chmod +x -R /opt/istio-$ISTIO_VERSION/
      ln -s /opt/istio-$ISTIO_VERSION/bin/istioctl /usr/local/bin/istioctl
      bashas "echo 'y' | istioctl manifest apply"
      waitForAllPods
    fi
}

helmInstall(){
    if [ "$helm_install" = true ] ; then
      printInfo " *****  Installing HELM Client v$HELM_VERSION ***** "
      wget -O getHelm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get
      chmod +x getHelm.sh
      ./getHelm.sh -v v$HELM_VERSION
      helm init 
    fi
}

certmanagerInstall(){
    if [ "$certmanager_install" = true ] ; then
      printInfo " ***** Install CertManager ***** "
      bashas "kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v$CERTMANAGER_VERSION/cert-manager.yaml"
      waitForAllPods
    fi
}

certmanagerEnable(){
    if [ "$certmanager_enable" = true ] ; then
      printInfo " ***** Installing ClusterIssuer with HTTP Letsencrypt ***** "
      bashas "kubectl apply -f ~/keptn-in-a-box/resources/istio/clusterissuer.yaml"
      waitForAllPods
      printInfo " ***** Create Valid SSL Certificates ***** "
      if [ "$resources_route_istio_ingress" = true ] ; then
        printInfo " ***** Route Traffic to IstioGateway and for known Istio Endpoints with SSL **** "
        bashas "cd ~/keptn-in-a-box/resources/istio && bash expose-ssl-istio.sh \"$DOMAIN\""
      fi
      if [ "$microk8s_expose_kubernetes_api" = true ] ; then
        printInfo " **** Exposing the Kubernetes Cluster API with SSL *****"
        bashas "cd ~/keptn-in-a-box/resources/k8-services && bash expose-kubernetes-api-ssl.sh \"$DOMAIN\""
      fi
    fi
}

keptndemoDeployCartsloadgenerator(){
    # https://github.com/sergiohinojosa/keptn-in-a-box/resources/cartsloadgenerator
    if [ "$keptndemo_cartsload" = true ] ; then
      printInfo " ***** Deploy Cartsload Generator ***** "
      bashas "kubectl create deploy cartsloadgen --image=shinojosa/cartsloadgen:keptn"
    fi
}

resourcesClone(){
    if [ "$resources_clone" = true ] ; then
      printInfo " ***** Clone Keptn-in-a-Box Resources ***** "
      bashas "git clone $KEPTN_IN_A_BOX_REPO ~/keptn-in-a-box"
    fi
}

keptnExamplesClone(){
    if [ "$keptn_examples_clone" = true ] ; then
      printInfo " ***** Clone Keptn Exmaples ***** "
      bashas "git clone --branch $KEPTN_EXAMPLES_BRANCH https://github.com/keptn/examples.git ~/examples --single-branch"
    fi
}

dynatraceSaveCredentials(){
    if [ "$dynatrace_savecredentials" = true ] ; then
      printInfo " ***** Save Dynatrace credentials ***** "
      bashas "cd ~/keptn-in-a-box/resources/dynatrace/ ; bash save-credentials.sh \"$DT_TENANT\" \"$PAASTOKEN\" \"$APITOKEN\""
    fi
}

resourcesRouteIstioIngress(){
    if [ "$resources_route_istio_ingress" = true ] ; then
      printInfo " ***** Route Traffic to IstioGateway and for known Istio Endpoints **** "
      bashas "cd ~/keptn-in-a-box/resources/istio && bash expose-istio.sh \"$DOMAIN\""
    fi
}

keptnInstall(){
    if [ "$keptn_install" = true ] ; then
      printInfo " ***** Download & Configure Keptn Client **** "
      wget -q -O keptn.tar "https://github.com/keptn/keptn/releases/download/${KEPTN_VERSION}/${KEPTN_VERSION}_keptn-linux.tar"
      tar -xvf keptn.tar
      chmod +x keptn 
      mv keptn /usr/local/bin/keptn
      printInfo " ***** Install Keptn with own installer passing DOMAIN via Parameter (omiting istio val) **** "
      bashas "echo 'y' | keptn install --platform=kubernetes --ingress-install-option=Reuse --domain $DOMAIN --keptn-installer-image=shinojosa/keptninstaller:6.2"
    fi
}

keptndemoTeaserPipeline(){
    if [ "$keptndemo_teaser_pipeline" = true ] ; then
      printInfo " ***** Deploying the Autonomous Cloud (dynamic) Teaser with Pipeline overview  ***** "
      bashas "kubectl -n istio-system create deploy homepage --image=${TEASER_IMAGE}"
      bashas "kubectl -n istio-system expose deploy homepage --port=80 --type=NodePort"
    fi
}

dynatraceConfigureMonitoring(){
    if [ "$dynatrace_configure_monitoring" = true ] ; then
      printInfo " ***** Installing and configuring Dynatrace OneAgent on the Cluster (via Keptn) *****"
      bashas "kubectl -n keptn create secret generic dynatrace --from-literal=\"DT_TENANT=$DT_TENANT\" --from-literal=\"DT_API_TOKEN=$DT_API_TOKEN\"  --from-literal=\"DT_PAAS_TOKEN=$DT_PAAS_TOKEN\""
      bashas "kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-service/$KEPTN_DT_SERVICE_VERSION/deploy/manifests/dynatrace-service/dynatrace-service.yaml"
      bashas "kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-sli-service/$KEPTN_DT_SLI_SERVICE_VERSION/deploy/service.yaml"
      printInfo " ***** Wait for the Service to be created *****"
      waitForAllPods
      bashas "keptn configure monitoring dynatrace"
      waitForAllPods
    fi
}

keptnBridgeExpose(){
    if [ "$keptn_bridge_expose" = true ] ; then
      printInfo " ***** IExpose Bridge via VS *****"
      KEPTN_DOMAIN=$(bashas "kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain}")
      bashas "cd ~/keptn-in-a-box/resources/expose-bridge && bash expose-bridge.sh \"$KEPTN_DOMAIN\"" 
    fi
}

keptnBridgeEap(){
    if [ "$keptn_bridge_eap" = true ] ; then
      printInfo " *****  Keptn Bridge update to EAP   ***** "
      bashas "kubectl -n keptn set image deployment/bridge bridge=${KEPTN_BRIDGE_IMAGE} --record"
    fi
}

keptndemoUnleash(){
    if [ "$keptndemo_unleash" = true ] ; then
      printInfo " *****  Deploy Unleash-Server  ***** "
      bashas "cd ~/examples/unleash-server/ && bash ~/keptn-in-a-box/resources/demo/deploy_unleashserver.sh" 
    fi
}

dynatraceConfigureWorkloads(){
    if [ "$dynatrace_configure_workloads" = true ] ; then
      printInfo " ***** Configuring Dynatrace Workloads for the Cluster (via Dynatrace and K8 API) *****"
      bashas "cd ~/keptn-in-a-box/resources/dynatrace && bash configure-k8.sh" 
    fi
}

microk8sExposeKubernetesApi(){
    if [ "$microk8s_expose_kubernetes_api" = true ] ; then
      printInfo " **** Exposing the Kubernetes Cluster API *****"
      bashas "cd ~/keptn-in-a-box/resources/k8-services && bash expose-kubernetes-api.sh \"$DOMAIN\""
    fi
}

microk8sExposeKubernetesDashboard(){
    if [ "$microk8s_expose_kubernetes_dashboard" = true ] ; then
      printInfo " **** Exposing the Kubernetes Dashboard *****"
      bashas "cd ~/keptn-in-a-box/resources/k8-services && bash expose-kubernetes-dashboard.sh \"$DOMAIN\"" 
    fi
}

keptndemoCartsonboard(){
    if [ "$keptndemo_cartsonboard" = true ] ; then
      printInfo " **** Keptn onboarding Carts *****"
      bashas "cd ~/examples/onboarding-carts/ && bash ~/keptn-in-a-box/resources/demo/onboard_carts.sh && bash ~/keptn-in-a-box/resources/demo/onboard_carts_qualitygates.sh"
      bashas "cd ~/examples/onboarding-carts/ && bash ~/keptn-in-a-box/resources/demo/deploy_carts_0.sh"
    fi
}

createWorkshopUser(){
    if [ "$create_workshop_user" = true ] ; then
      printInfo " **** Creating Workshop User from user($USER) into($NEWUSER) *****"
      homedirectory=$(eval echo ~$USER)
      cp -R $homedirectory /home/$NEWUSER
      useradd -s /bin/bash -d /home/$NEWUSER -m -G sudo -p $(openssl passwd -1 $NEWPWD) $NEWUSER
      usermod -a -G docker $NEWUSER
      usermod -a -G microk8s $NEWUSER
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      service sshd restart
    fi
}

printInstalltime(){
    DURATION=$SECONDS
    printInfo "***** Installation complete :) *****\nIt took $(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds "
    printInfo "***** Keptn & Kubernetes Exposed Ingress Endpoints ***** "
    bashas "kubectl get ing -A"
}

doInstallation(){
  printInfo ""
  printInfo "***** Init Installation at  `date` by user `whoami` ****"
  printInfo "***** Setting up Microk8s (SingleNode K8s Dev Cluster) with Keptn ****"
  printInfo ""
  # Record time of installation
  SECONDS=0
  
  setBashas
  
  dynatracePrintValidateCredentials

  enableVerbose
  updateUbuntu

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
  resourcesClone
  keptnExamplesClone
  dynatraceSaveCredentials

  setupMagicDomainPublicIp

  microk8sExposeKubernetesApi
  microk8sExposeKubernetesDashboard
  resourcesRouteIstioIngress
  keptnInstall
  keptndemoTeaserPipeline
  keptndemoUnleash
  dynatraceConfigureMonitoring
  dynatraceConfigureWorkloads
  keptnBridgeExpose
  keptnBridgeEap
  keptndemoCartsonboard
  keptndemoDeployCartsloadgenerator
  createWorkshopUser
  certmanagerEnable
  printInstalltime
  # TODO print Ingress Hosts in a nicer way
  # TODO Add wrapper shell to load and call functions with parameters
}

printInfo "Keptn-in-a-Box installation functions loaded in the current shell"