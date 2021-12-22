#!/bin/bash
# This file contains the functions for installing Keptn-in-a-Box.
# Each function contains a boolean flag so the installations
# can be highly customized.

# ==================================================
#      ----- Components Versions -----             #
# ==================================================
KIAB_RELEASE="release-0.10.0"

#https://cert-manager.io/docs/release-notes/
CERTMANAGER_VERSION=0.14.0
#https://istio.io/latest/news/releases/
ISTIO_VERSION=1.9.1
# https://github.com/helm/helm/releases
HELM_VERSION=3.5.0
# https://github.com/keptn/keptn
KEPTN_VERSION=0.10.0
# https://github.com/keptn-contrib/dynatrace-service
KEPTN_DT_SERVICE_VERSION=0.18.1

# https://github.com/keptn/examples
KEPTN_EXAMPLES_BRANCH="0.10.0"
TEASER_IMAGE="shinojosa/kiab:0.8"
# https://github.com/ubuntu/microk8s/releases
# snap info microk8s
MICROK8S_CHANNEL="1.19/stable"
KEPTN_IN_A_BOX_DIR="~/keptn-in-a-box"
KEPTN_EXAMPLES_DIR="~/examples"
KEPTN_IN_A_BOX_REPO="https://github.com/keptn-sandbox/keptn-in-a-box.git"
DEVLOVE_ET_REPO="https://github.com/dynatrace-perfclinics/devlove-easytravel-pipelines.git"
DEVLOVE_ET_DIR="~/devlove-easytravel-pipelines"

# - The user to run the commands from. Will be overwritten when executing this shell with sudo, this is just needed when spinning machines programatically and running the script with root without an interactive shell
USER="ubuntu"

# Comfortable function for setting the sudo user.
if [ -n "${SUDO_USER}" ]; then
  USER=$SUDO_USER
fi
echo "running sudo commands as $USER"

# Wrapper for runnig commands for the real owner and not as root
alias bashas="sudo -H -u ${USER} bash -c"
# Expand aliases for non-interactive shell
shopt -s expand_aliases

# ======================================================================
#       -------- Function boolean flags ----------                     #
#  Each function flag representas a function and will be evaluated     #
#  before execution.                                                   #
# ======================================================================
# If you add varibles here, dont forget the function definition and the priting in printFlags function.
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
keptn_install_qualitygates=false
keptn_examples_clone=false
resources_clone=false

git_deploy=false
git_migrate=false

dynatrace_savecredentials=false
dynatrace_configure_monitoring=false

jenkins_deploy=false

devlove_easytravel=false

keptn_bridge_disable_login=false
keptndeploy_homepage=false
keptndemo_cartsload=false
keptndemo_unleash=false
keptndemo_unleash_configure=false
keptndemo_cartsonboard=false
expose_kubernetes_api=false
expose_kubernetes_dashboard=false
patch_kubernetes_dashboard=false
create_workshop_user=false

# ======================================================================
#             ------- Installation Bundles  --------                   #
#  Each bundle has a set of modules (or functions) that will be        #
#  activated upon installation.                                        #
# ======================================================================
installationBundleDemo() {
  selected_bundle="installationBundleDemo"
  update_ubuntu=true
  docker_install=true
  microk8s_install=true
  setup_proaliases=true

  enable_k8dashboard=false
  istio_install=true
  helm_install=true

  certmanager_install=false
  certmanager_enable=false

  keptn_install=true
  keptn_examples_clone=true
  resources_clone=true

  git_deploy=true
  git_migrate=true

  dynatrace_savecredentials=true
  dynatrace_configure_monitoring=true

  keptndeploy_homepage=true
  keptndemo_cartsload=true
  keptndemo_unleash=true
  keptndemo_unleash_configure=true
  keptndemo_cartsonboard=true
  expose_kubernetes_api=true
  expose_kubernetes_dashboard=false
  patch_kubernetes_dashboard=false
  keptn_bridge_disable_login=true
  # By default no WorkshopUser will be created
  create_workshop_user=false
}

installationBundleWorkshop() {
  installationBundleDemo
  enable_registry=false
  create_workshop_user=true
  expose_kubernetes_api=true
  expose_kubernetes_dashboard=true
  enable_k8dashboard=true
  patch_kubernetes_dashboard=true
  keptn_bridge_disable_login=true

  selected_bundle="installationBundleWorkshop"
}

installationBundleDevLove() {
  selected_bundle="installationBundleDevLove"
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

  git_deploy=true
  git_migrate=true

  dynatrace_savecredentials=true
  dynatrace_configure_monitoring=true

  keptndeploy_homepage=true

  keptndemo_cartsload=false
  keptndemo_unleash=false
  keptndemo_unleash_configure=false
  keptndemo_cartsonboard=false
  
  expose_kubernetes_api=true
  expose_kubernetes_dashboard=true
  patch_kubernetes_dashboard=true
  keptn_bridge_disable_login=true
  # By default no WorkshopUser will be created
  create_workshop_user=true
  devlove_easytravel=true

}

installationBundleAll() {
  # installation default
  installationBundleWorkshop

  enable_registry=true
  # plus all others
  certmanager_install=true
  certmanager_enable=true
  create_workshop_user=true
  keptn_bridge_disable_login=true

  jenkins_deploy=true

  selected_bundle="installationBundleAll"
}

installationBundleKeptnOnly() {
  # The minimal to have a full keptn working
  # with exposed istio and keptn over nginx
  update_ubuntu=true
  docker_install=true
  microk8s_install=true
  enable_k8dashboard=true

  setup_proaliases=true
  istio_install=true
  keptn_install=true
  helm_install=true
  keptn_examples_clone=true
  resources_clone=true

  dynatrace_savecredentials=true
  dynatrace_configure_monitoring=true

  expose_kubernetes_api=true
  expose_kubernetes_dashboard=true

  keptndeploy_homepage=true

  selected_bundle="installationBundleKeptnOnly"
}

installationBundleKeptnQualityGates() {
  installationBundleKeptnOnly

  # We dont need istio nor helm
  istio_install=false
  helm_install=false

  # For the QualityGates we need both flags needs to be enabled
  keptn_install_qualitygates=true

  selected_bundle="installationBundleKeptnQualityGates"
}

installationBundlePerformanceAsAService() {
  installationBundleKeptnQualityGates

  # Jenkins needs Helm for the Chart to be installed
  helm_install=true
  jenkins_deploy=true

  selected_bundle="installationBundlePerformanceAsAService"
}

# ======================================================================
#          ------- Util Functions -------                              #
#  A set of util functions for logging, validating and                 #
#  executing commands.                                                 #
# ======================================================================
thickline="======================================================================"
halfline="============"
thinline="______________________________________________________________________"

setBashas() {
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
  echo "[Keptn-In-A-Box|INFO] $(timestamp) |>->-> $1 <-<-<|"
}

printInfoSection() {
  echo "[Keptn-In-A-Box|INFO] $(timestamp) |$thickline"
  echo "[Keptn-In-A-Box|INFO] $(timestamp) |$halfline $1 $halfline"
  echo "[Keptn-In-A-Box|INFO] $(timestamp) |$thinline"
}

printWarn() {
  echo "[Keptn-In-A-Box|WARN] $(timestamp) |x-x-> $1 <-x-x|"
}

printError() {
  echo "[Keptn-In-A-Box|ERROR] $(timestamp) |x-x-> $1 <-x-x|"
}

validateSudo() {
  if [[ $EUID -ne 0 ]]; then
    printError "Keptn-in-a-Box must be run with sudo rights. Exiting installation"
    exit 1
  fi
  printInfo "Keptn-in-a-Box installing with sudo rights:ok"
}

waitForAllPods() {
  # Function to filter by Namespace, default is ALL
  if [[ $# -eq 1 ]]; then
    namespace_filter="-n $1"
  else
    namespace_filter="--all-namespaces"
  fi
  RETRY=0
  RETRY_MAX=24
  # Get all pods, count and invert the search for not running nor completed. Status is for deleting the last line of the output
  CMD="bashas \"kubectl get pods $namespace_filter 2>&1 | grep -c -v -E '(Running|Completed|Terminating|STATUS)'\""
  printInfo "Checking and wait for all pods in \"$namespace_filter\" to run."
  while [[ $RETRY -lt $RETRY_MAX ]]; do
    pods_not_ok=$(eval "$CMD")
    if [[ "$pods_not_ok" == '0' ]]; then
      printInfo "All pods are running."
      break
    fi
    RETRY=$(($RETRY + 1))
    printWarn "Retry: ${RETRY}/${RETRY_MAX} - Wait 10s for $pods_not_ok PoDs to finish or be in state Running ..."
    sleep 10
  done

  if [[ $RETRY == $RETRY_MAX ]]; then
    printError "Following pods are not still not running. Please check their events. Exiting installation..."
    bashas "kubectl get pods --field-selector=status.phase!=Running -A"
    exit 1
  fi
}

waitForServersAvailability() {
  # expand function to wait for git curl 200 / eval RC
  if [[ $# -eq 1 ]]; then
    URL="$1"
  else
    printError "You need to define a URL to check a server's availability e.g. http://server.com/ "
    exit 1
  fi
  RETRY=0
  RETRY_MAX=24
  # Get all pods, count and invert the search for not running nor completed. Status is for deleting the last line of the output
  CMD="curl --write-out '%{http_code}' --silent --output /dev/null $URL"
  printInfo "Checking availability for URL  \"$URL\"."
  while [[ $RETRY -lt $RETRY_MAX ]]; do
    response=$(eval "$CMD")
    if [[ "$response" == '200' ]]; then
      printInfo "URL return 200."
      break
    fi
    RETRY=$(($RETRY + 1))
    printWarn "Retry: ${RETRY}/${RETRY_MAX} - Wait 10s for $URL to be available... RC is $response"
    sleep 10
  done
  if [[ $RETRY == $RETRY_MAX ]]; then
    printError "URL $URL is still not available. Exiting..."
    exit 1
  fi
}

enableVerbose() {
  if [ "$verbose_mode" = true ]; then
    printInfo "Activating verbose mode"
    set -x
  fi
}

printFileSystemUsage() {
  printInfoSection "File System usage"
  bashas 'df -h /'
}

printSystemInfo() {
  printInfoSection "Print System Information"
  printInfoSection "CPU Architecture"
  bashas 'lscpu'
  printInfoSection "Memory Information"
  bashas 'lsmem'
  printFileSystemUsage
}

# Function to convert 1K Blocks in IEC Formating (.e.g. 1M)
getDiskUsageInIec() {
  echo $(($1 * 1024)) | numfmt --to=iec
}

# Function to return the Available Usage of the Disk space in K Blocks (1024)
getUsedDiskSpace() {
  echo $(df / | tail -1 | awk '{print $3}')
}

# ======================================================================
#          ----- Installation Functions -------                        #
# The functions for installing the different modules and capabilities. #
# Some functions depend on each other, for understanding the order of  #
# execution see the function doInstallation() defined at the bottom    #
# ======================================================================
updateUbuntu() {
  if [ "$update_ubuntu" = true ]; then
    printInfoSection "Updating Ubuntu apt registry"
    apt update
  fi
}

dynatracePrintValidateCredentials() {
  printInfoSection "Printing Dynatrace Credentials"
  if [ -n "${TENANT}" ]; then
    printInfo "Shuffle the variables for name convention with Keptn & Dynatrace"
    PROTOCOL="https://"
    DT_TENANT=${TENANT#"$PROTOCOL"}
    printInfo "Cleaned tenant=$DT_TENANT"
    DT_API_TOKEN=$APITOKEN
    DT_PAAS_TOKEN=$PAASTOKEN
    printInfo "-------------------------------"
    printInfo "Dynatrace Tenant: $DT_TENANT"
    printInfo "Dynatrace API Token: $DT_API_TOKEN"
    printInfo "Dynatrace PaaS Token: $DT_PAAS_TOKEN"
  else
    printInfoSection "Dynatrace Variables not set, Dynatrace wont be installed"
    dynatrace_savecredentials=false
    dynatrace_configure_monitoring=false
  fi
}

dependenciesInstall() {
  printInfoSection "Installing dependencies"
  printInfo "Install snap"
  apt install snapd -y
  printInfo "Install git"
  apt install git -y
  printInfo "Install jq"
  apt install jq -y
}

dockerInstall() {
  if [ "$docker_install" = true ]; then
    printInfoSection "Installing Docker"
    apt install docker.io -y
    service docker start
    usermod -a -G docker $USER
  fi
}

setupProAliases() {
  if [ "$setup_proaliases" = true ]; then
    printInfoSection "Adding Bash and Kubectl Pro CLI aliases to .bash_aliases for user ubuntu and root "
    echo "
      # Alias for ease of use of the CLI
      alias las='ls -las' 
      alias hg='history | grep' 
      alias h='history' 
      alias vaml='vi -c \"set syntax:yaml\" -' 
      alias vson='vi -c \"set syntax:json\" -' 
      alias pg='ps -aux | grep' " >/root/.bash_aliases
    homedir=$(eval echo ~$USER)
    cp /root/.bash_aliases $homedir/.bash_aliases
  fi
}

setupMagicDomainPublicIp() {
  printInfoSection "Setting up the Domain"
  if [ -n "${DOMAIN}" ]; then
    printInfo "The following domain is defined: $DOMAIN"
    export DOMAIN
  else
    printInfo "No DOMAIN is defined, converting the public IP in a magic nip.io domain"
    # https://unix.stackexchange.com/a/81699/37512
    PUBLIC_IP_AS_DOM=$(dig @resolver4.opendns.com myip.opendns.com +short -4 | sed 's~\.~-~g')
    export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"
    printInfo "Magic Domain: $DOMAIN"
  fi
  # Now we save the DOMAIN in a ConfigMap
  bashas "kubectl create configmap -n default domain --from-literal=domain=${DOMAIN}"
}

microk8sInstall() {
  if [ "$microk8s_install" = true ]; then
    printInfoSection "Installing Microkubernetes with Kubernetes Version $MICROK8S_CHANNEL"
    snap install microk8s --channel=$MICROK8S_CHANNEL --classic

    printInfo "allowing the execution of priviledge pods "
    bash -c "echo \"--allow-privileged=true\" >> /var/snap/microk8s/current/args/kube-apiserver"

    printInfo "Add user $USER to microk8 usergroup"
    usermod -a -G microk8s $USER

    printInfo "Update IPTABLES, allow traffic for pods (internal and external) "
    iptables -P FORWARD ACCEPT
    ufw allow in on cni0 && sudo ufw allow out on cni0
    ufw default allow routed

    printInfo "Add alias to Kubectl (Bash completion for kubectl is already enabled in microk8s)"
    snap alias microk8s.kubectl kubectl

    printInfo "Add Snap to the system wide environment."
    sed -i 's~/usr/bin:~/usr/bin:/snap/bin:~g' /etc/environment

    printInfo "Create kubectl file for the user"
    homedirectory=$(eval echo ~$USER)
    bashas "mkdir $homedirectory/.kube"
    bashas "microk8s.config > $homedirectory/.kube/config"
    bashas "chmod 700 $homedirectory/.kube/config"
  fi
}

microk8sStart() {
  printInfoSection "Starting Microk8s"
  bashas 'microk8s.start'
}

microk8sEnableBasic() {
  printInfoSection "Enable DNS, Storage, NGINX Ingress"
  bashas 'microk8s.enable dns'
  waitForAllPods
  bashas 'microk8s.enable storage'
  waitForAllPods
  bashas 'microk8s.enable ingress'
  #TODO remove workaround. status.quay.io is not working. Downloading from mirror. 
  bashas 'kubectl -n ingress set image daemonset.apps/nginx-ingress-microk8s-controller nginx-ingress-microk8s=gcr.io/k8s-staging-ingress-nginx/nginx-ingress-controller:0.33.0'
  waitForAllPods
}

microk8sEnableDashboard() {
  if [ "$enable_k8dashboard" = true ]; then
    printInfoSection " Enable Kubernetes Dashboard"
    bashas 'microk8s.enable dashboard'
    waitForAllPods
  fi
}

microk8sEnableRegistry() {
  if [ "$enable_registry" = true ]; then
    printInfoSection "Enable own Docker Registry"
    bashas 'microk8s.enable registry'
    waitForAllPods
  fi
}

# We install via istioctl, we control the istio version and its components. It's also the recommended way for istio.
# Via microk8 addon it enables lots of other stuff
istioInstall() {
  if [ "$istio_install" = true ]; then
    printInfoSection "Install istio $ISTIO_VERSION into /opt and add it to user/local/bin"
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -
    mv istio-$ISTIO_VERSION /opt/istio-$ISTIO_VERSION
    chmod +x -R /opt/istio-$ISTIO_VERSION/
    ln -s /opt/istio-$ISTIO_VERSION/bin/istioctl /usr/local/bin/istioctl
    bashas "echo 'y' | istioctl install"
    waitForAllPods
  fi
}

helmInstall() {
  if [ "$helm_install" = true ]; then
    printInfoSection "Installing HELM ${HELM_VERSION} & Client manually from binaries"
    wget -q -O helm.tar.gz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
    tar -xvf helm.tar.gz
    mv linux-amd64/helm /usr/local/bin/helm    
    printInfo "Adding Default repo for Helm"
    bashas "helm repo add stable https://charts.helm.sh/stable"
    printInfo "Adding Jenkins repo for Helm"
    bashas "helm repo add jenkins https://charts.jenkins.io"
    printInfo "Adding GiteaCharts for Helm"
    bashas "helm repo add gitea-charts https://dl.gitea.io/charts/"
    printInfo "Updating Helm Repository"
    bashas "helm repo update"
  fi
}

certmanagerInstall() {
  if [ "$certmanager_install" = true ]; then
    printInfoSection "Install CertManager $CERTMANAGER_VERSION with Email Account ($CERTMANAGER_EMAIL)"
    bashas "kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v$CERTMANAGER_VERSION/cert-manager.yaml"
    waitForAllPods
  fi
}

certmanagerEnable() {
  if [ "$certmanager_enable" = true ]; then
    printInfoSection "Installing ClusterIssuer with HTTP Letsencrypt for ($CERTMANAGER_EMAIL)"

    #bashas "kubectl apply -f $KEPTN_IN_A_BOX_DIR/resources/ingress/clusterissuer.yaml"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-clusterissuer.sh $CERTMANAGER_EMAIL"
    waitForAllPods
    printInfo "Creating SSL Certificates with Let's encrypt for the exposed ingresses"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash add-ssl-certificates.sh"

    printInfoSection "Let's Encrypt Process in kubectl for CertManager"
    printInfo " For observing the creation of the certificates: \n
              kubectl describe clusterissuers.cert-manager.io -A
              kubectl describe issuers.cert-manager.io -A
              kubectl describe certificates.cert-manager.io -A
              kubectl describe certificaterequests.cert-manager.io -A
              kubectl describe challenges.acme.cert-manager.io -A
              kubectl describe orders.acme.cert-manager.io -A
              kubectl get events
              "
  fi
}

keptndemoDeployCartsloadgenerator() {
  # https://github.com/sergiohinojosa/keptn-in-a-box/resources/cartsloadgenerator
  if [ "$keptndemo_cartsload" = true ]; then
    printInfoSection "Deploy Cartsload Generator"
    bashas "kubectl create deploy cartsloadgen --image=shinojosa/cartsloadgen:keptn"
  fi
}

resourcesClone() {
  if [ "$resources_clone" = true ]; then
    printInfoSection "Clone Keptn-in-a-Box Resources in $KEPTN_IN_A_BOX_DIR"
    bashas "git clone --branch $KIAB_RELEASE $KEPTN_IN_A_BOX_REPO $KEPTN_IN_A_BOX_DIR --single-branch"
  fi
}

keptnExamplesClone() {
  if [ "$keptn_examples_clone" = true ]; then
    printInfoSection "Clone Keptn Exmaples $KEPTN_EXAMPLES_BRANCH"
    bashas "git clone --branch $KEPTN_EXAMPLES_BRANCH https://github.com/keptn/examples.git $KEPTN_EXAMPLES_DIR --single-branch"
  fi
}

dynatraceSaveCredentials() {
  if [ "$dynatrace_savecredentials" = true ]; then
    printInfoSection "Save Dynatrace credentials"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace/ ; bash save-credentials.sh \"$DT_TENANT\" \"$APITOKEN\" \"$PAASTOKEN\""
  fi
}

keptnInstallClient() {
  printInfoSection "Download Keptn $KEPTN_VERSION"
  wget -q -O keptn.tar.gz "https://github.com/keptn/keptn/releases/download/${KEPTN_VERSION}/keptn-${KEPTN_VERSION}-linux-amd64.tar.gz"
  tar -xvf keptn.tar.gz
  mv keptn-${KEPTN_VERSION}-linux-amd64 keptn
  chmod +x keptn
  mv keptn /usr/local/bin/keptn
  printInfo "Remove keptn.tar.gz"
  rm keptn.tar.gz
}

keptnInstall() {
  if [ "$keptn_install" = true ]; then

    keptnInstallClient

    if [ "$keptn_install_qualitygates" = true ]; then
      printInfoSection "Install Keptn with Continuous Delivery UseCase (no Istio configuration)"

      bashas "echo 'y' | keptn install"
      waitForAllPods
    else
      ## -- Keptn Installation --
      printInfoSection "Install Keptn with Continuous Delivery UseCase"
      bashas "echo 'y' | keptn install --use-case=continuous-delivery"
      waitForAllPods

      # Adding configuration for the IngressGW
      printInfoSection "Creating Public Gateway for Istio"
      bashas "cd $KEPTN_IN_A_BOX_DIR/resources/istio && kubectl apply -f public-gateway.yaml"

      printInfoSection "Configuring Istio for Keptn"
      bashas "kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=${DOMAIN} --from-literal=ingress_port=80 --from-literal=ingress_protocol=http --from-literal=istio_gateway=public-gateway.istio-system -oyaml --dry-run | kubectl replace -f -"

      printInfo "Restart Keptn Helm Service for the istio service mesh"
      bashas "kubectl delete pod -n keptn -lapp.kubernetes.io/name=helm-service"
    fi

    printInfoSection "Routing for the Keptn Services via NGINX Ingress"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} api-keptn-ingress"
    waitForAllPods

    # We sleep for 5 seconds to give time the Ingress to be ready
    sleep 5
    printInfoSection "Authenticate Keptn CLI"
    KEPTN_ENDPOINT=https://$(kubectl get ing -n keptn api-keptn-ingress -o=jsonpath='{.spec.tls[0].hosts[0]}')/api
    KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
    KEPTN_BRIDGE_URL=http://$(kubectl -n keptn get ingress api-keptn-ingress -ojsonpath='{.spec.rules[0].host}')/bridge
    bashas "keptn auth --endpoint=$KEPTN_ENDPOINT --api-token=$KEPTN_API_TOKEN"
  fi
}

keptnDeployHomepage() {
  if [ "$keptndeploy_homepage" = true ]; then
    printInfoSection "Deploying the Autonomous Cloud (dynamic) Teaser with Pipeline overview $TEASER_IMAGE"
    bashas "kubectl -n default create deploy homepage --image=${TEASER_IMAGE}"
    bashas "kubectl -n default expose deploy homepage --port=80 --type=NodePort"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} homepage"
  fi
}

jenkinsDeploy() {
  if [ "$jenkins_deploy" = true ]; then
    printInfoSection "Deploying Jenkins via Helm. This Jenkins is configured and managed 'as code'"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/jenkins && bash deploy-jenkins.sh ${DOMAIN}"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} jenkins"
  fi
}

gitDeploy() {
  if [ "$git_deploy" = true ]; then
    printInfoSection "Deploying self-hosted GIT(ea) service via Helm."
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/gitea && bash deploy-gitea.sh ${DOMAIN}"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} gitea"
  fi
}

gitMigrate() {
  if [ "$git_migrate" = true ]; then
    printInfoSection "Migrating Keptn projects to a self-hosted GIT(ea) service."
    waitForAllPods git
    GIT_SERVER="http://git.$DOMAIN"
    waitForServersAvailability ${GIT_SERVER}
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/gitea && bash update-git-keptn.sh ${DOMAIN}"
  fi
}

dynatraceConfigureMonitoring() {
  if [ "$dynatrace_configure_monitoring" = true ]; then
    printInfoSection "Installing and configuring Dynatrace OneAgent on the Cluster for $DT_TENANT"

    printInfo "Saving Credentials in dynatrace secret in keptn ns"
    kubectl -n keptn create secret generic dynatrace --from-literal="DT_TENANT=$DT_TENANT" --from-literal="DT_API_TOKEN=$DT_API_TOKEN" --from-literal="DT_PAAS_TOKEN=$DT_PAAS_TOKEN" --from-literal="KEPTN_API_URL=http://$(kubectl -n keptn get ingress api-keptn-ingress -ojsonpath='{.spec.rules[0].host}')/api" --from-literal="KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath='{.data.keptn-api-token}' | base64 --decode)" --from-literal="KEPTN_BRIDGE_URL=http://$(kubectl -n keptn get ingress api-keptn-ingress -ojsonpath='{.spec.rules[0].host}')/bridge"

    # Deploy Operator as Help pages with containerized AG
    printInfo "Deploying the OneAgent Operator and containerized AG monitoring all events and Cluster Health"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/dynatrace && echo 'y' | bash deploy_operator.sh"

    printInfo "Deploying the Dynatrace Service $KEPTN_DT_SERVICE_VERSION in Keptn via Helm"
    bashas "helm upgrade --install dynatrace-service -n keptn https://github.com/keptn-contrib/dynatrace-service/releases/download/$KEPTN_DT_SERVICE_VERSION/dynatrace-service-$KEPTN_DT_SERVICE_VERSION.tgz --set dynatraceService.config.keptnApiUrl=$KEPTN_ENDPOINT --set dynatraceService.config.keptnBridgeUrl=$KEPTN_BRIDGE_URL --set dynatraceService.config.generateTaggingRules=true --set dynatraceService.config.generateProblemNotifications=true --set dynatraceService.config.generateManagementZones=true --set dynatraceService.config.generateDashboards=true --set dynatraceService.config.generateMetricEvents=true"

    waitForAllPods
    bashas "keptn configure monitoring dynatrace"
    waitForAllPods
  fi
}

keptnBridgeDisableLogin() {
  if [ "$keptn_bridge_disable_login" = true ]; then
    printInfoSection "Keptn Bridge disabling Login"
    bashas "kubectl -n keptn delete secret bridge-credentials"
    bashas "kubectl -n keptn delete pods --selector=app.kubernetes.io/name=bridge"
  fi
}

keptndemoUnleash() {
  if [ "$keptndemo_unleash" = true ]; then
    printInfoSection "Deploy Unleash-Server"
    bashas "cd $KEPTN_EXAMPLES_DIR/unleash-server/ &&  bash $KEPTN_IN_A_BOX_DIR/resources/demo/deploy_unleashserver.sh"

    printInfoSection "Expose Unleash-Server"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} unleash"
  fi
}

keptndemoUnleashConfigure() {
  if [ "$keptndemo_unleash_configure" = true ]; then

    UNLEASH_TOKEN=$(echo -n keptn:keptn | base64)
    UNLEASH_SERVER="http://unleash.unleash-dev.$DOMAIN"
    
    waitForServersAvailability ${UNLEASH_SERVER}

    printInfoSection "Enable Feature Flags for Unleash and Configure Keptn for it"
    bashas "cd $KEPTN_EXAMPLES_DIR/onboarding-carts/ &&  bash $KEPTN_IN_A_BOX_DIR/resources/demo/unleash_add_featureflags.sh ${UNLEASH_SERVER}"
    printInfoSection "No load generation will be created for running the experiment"
    printInfoSection "You can trigger the experiment manually here: https://tutorials.keptn.sh/tutorials/keptn-full-tour-dynatrace-09/#27"
  fi
}

exposeK8Services() {
  if [ "$expose_kubernetes_api" = true ]; then
    printInfoSection "Exposing the Kubernetes Cluster API"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} k8-api"
  fi
  if [ "$expose_kubernetes_dashboard" = true ]; then
    printInfoSection "Exposing the Kubernetes Dashboard"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} k8-dashboard"
  fi
  if [ "$istio_install" = true ]; then
    printInfoSection "Exposing Istio Service Mesh as fallBack for nonmapped hosts (subdomains)"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} istio-ingress"
  fi
}

patchKubernetesDashboard() {
  if [ "$patch_kubernetes_dashboard" = true ]; then
    printInfoSection "Patching Kubernetes Dashboard, use only for learning and Workshops"
    echo "Skip Login in K8 Dashboard"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/misc && bash patch-kubernetes-dashboard.sh"
  fi
}

keptndemoCartsonboard() {
  if [ "$keptndemo_cartsonboard" = true ]; then
    printInfoSection "Keptn onboarding Carts"

    bashas "cd $KEPTN_EXAMPLES_DIR/onboarding-carts/ && bash $KEPTN_IN_A_BOX_DIR/resources/demo/onboard_carts.sh && bash $KEPTN_IN_A_BOX_DIR/resources/demo/onboard_carts_qualitygates.sh"
    bashas "cd $KEPTN_EXAMPLES_DIR/onboarding-carts/ && bash $KEPTN_IN_A_BOX_DIR/resources/demo/deploy_carts_0.sh"

    printInfoSection "Keptn Exposing the Onboarded Carts Application"
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} sockshop"

  fi
}

devloveEasytravel() {
  if [ "$devlove_easytravel" = true ]; then
    printInfoSection "Why Devs Love Dynatrace Resources & Jenkins Configuration"

    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/jenkins && bash deploy-jenkins.sh ${DOMAIN}"
    # Create Ingress
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/ingress && bash create-ingress.sh ${DOMAIN} jenkins"
    # Create Easytravel Project
    bashas "cd $KEPTN_IN_A_BOX_DIR/resources/jenkins/pipelines/keptn_devlove/ && keptn create project easytravel --shipyard shipyard.yaml"
  fi
}

createWorkshopUser() {
  if [ "$create_workshop_user" = true ]; then
    printInfoSection "Creating Workshop User from user($USER) into($NEWUSER)"
    homedirectory=$(eval echo ~$USER)
    printInfo "copy home directories and configurations"
    cp -R $homedirectory /home/$NEWUSER
    printInfo "Create user $NEWUSER"
    useradd -s /bin/bash -d /home/$NEWUSER -m -G sudo -p $(openssl passwd -1 $NEWPWD) $NEWUSER
    printInfo "Change diretores rights -r"
    chown -R $NEWUSER:$NEWUSER /home/$NEWUSER
    usermod -a -G docker $NEWUSER
    usermod -a -G microk8s $NEWUSER
    printWarn "Warning: allowing SSH passwordAuthentication into the sshd_config"
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    service sshd restart
  fi
}

printInstalltime() {
  DURATION=$SECONDS
  printInfoSection "Installation complete :)"
  printInfo "It took $(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds"
  printFileSystemUsage
  DISK_USED=$(($DISK_FINAL - $DISK_INIT))
  printInfo "Disk used size 1K Blocks: $DISK_USED"
  printInfo "Disk used size in IEC Format: $(getDiskUsageInIec $DISK_USED)"

  printInfoSection "Keptn & Kubernetes Exposed Ingress Endpoints"
  printInfo "Below you'll find the adresses and the credentials to the exposed services."
  printInfo "We wish you a lot of fun in your Autonomous Cloud journey!"
  echo ""
  bashas "kubectl get ing -A"

  if [ "$keptn_bridge_disable_login" = false ]; then
    printInfoSection "Keptn Bridge Access"
    bashas "keptn configure bridge --output"
    echo ""
  fi

  if [ "$keptndemo_unleash" = true ]; then
    printInfoSection "Unleash-Server Access"
    printInfo "Username: keptn"
    printInfo "Password: keptn"
  fi

  if [ "$jenkins_deploy" = true ]; then
    printInfoSection "Jenkins-Server Access"
    printInfo "Username: keptn"
    printInfo "Password: keptn"
  fi

  if [ "$devlove_easytravel" = true ]; then
    printInfoSection "Jenkins-Server Access"
    printInfo "Username: keptn"
    printInfo "Password: keptn"
  fi

  if [ "$git_deploy" = true ]; then
    printInfoSection "Git-Server Access"
    bashas "bash $KEPTN_IN_A_BOX_DIR/resources/gitea/gitea-vars.sh ${DOMAIN}"
    printInfo "ApiToken to be found on $KEPTN_IN_A_BOX_DIR/resources/gitea/keptn-token.json"
    printInfo "For migrating keptn projects to your self-hosted git repository afterwards just execute the following function:"
    printInfo "cd $KEPTN_IN_A_BOX_DIR/resources/gitea/ && source ./gitea-functions.sh; createKeptnRepoManually {project-name}"
  fi

  if [ "$create_workshop_user" = true ]; then
    printInfoSection "Workshop User Access (SSH Access)"
    printInfo "ssh ${NEWUSER}@${DOMAIN}"
    printInfo "Password: ${NEWPWD}"
  fi

  printInfoSection "Keptn in a Box $KIAB_RELEASE installation finished."
  printInfo "Good luck in your Autonomous Cloud Journey!!"
  printInfo "If you faced an issue or just want to say hi, come by @ https://keptn.slack.com/"
}

printFlags() {
  printInfoSection "Function Flags values"
  for i in {selected_bundle,verbose_mode,update_ubuntu,docker_install,microk8s_install,setup_proaliases,enable_k8dashboard,enable_registry,istio_install,helm_install,git_deploy,git_migrate,certmanager_install,certmanager_enable,keptn_install,keptn_install_qualitygates,keptn_examples_clone,resources_clone,dynatrace_savecredentials,dynatrace_configure_monitoring,jenkins_deploy,keptn_bridge_disable_login,keptndeploy_homepage,keptndemo_cartsload,keptndemo_unleash,keptndemo_unleash_configure,keptndemo_cartsonboard,expose_kubernetes_api,expose_kubernetes_dashboard,patch_kubernetes_dashboard,create_workshop_user,devlove_easytravel}; do
    echo "$i = ${!i}"
  done
}

removeMicrok8s() {
  printInfoSection "Remove & Purge microk8s"
  printInfo "snap remove microk8s --purge"
  sudo snap remove microk8s --purge
  printInfo "If you want a complete uninstall remove this directories:"
  printInfo "rm -rf $KEPTN_IN_A_BOX_DIR"
  printInfo "rm -rf $KEPTN_EXAMPLES_DIR"
}

# ======================================================================
#            ---- The Installation function -----                      #
#  The order of the subfunctions are defined in a sequencial order     #
#  since ones depend on another.                                       #
# ======================================================================
doInstallation() {
  echo ""
  printInfoSection "Init Installation at  $(date) by user $(whoami)"
  printInfo "Setting up Microk8s (SingleNode K8s Dev Cluster) with Keptn"
  echo ""
  printSystemInfo
  # Record Disk Usage
  DISK_INIT=$(getUsedDiskSpace)
  # Record time of installation
  SECONDS=0

  printFlags

  echo ""
  validateSudo
  setBashas

  dynatracePrintValidateCredentials

  enableVerbose
  updateUbuntu
  setupProAliases

  dependenciesInstall
  dockerInstall
  microk8sInstall
  microk8sStart
  microk8sEnableBasic
  microk8sEnableDashboard
  microk8sEnableRegistry

  istioInstall
  helmInstall
  certmanagerInstall
  resourcesClone
  keptnExamplesClone
  dynatraceSaveCredentials

  setupMagicDomainPublicIp

  exposeK8Services
  patchKubernetesDashboard

  keptnInstall
  keptnDeployHomepage

  keptndemoUnleash

  dynatraceConfigureMonitoring
  keptnBridgeDisableLogin

  jenkinsDeploy

  gitDeploy

  keptndemoCartsonboard
  keptndemoDeployCartsloadgenerator
  keptndemoUnleashConfigure

  devloveEasytravel

  gitMigrate
  createWorkshopUser
  certmanagerEnable

  DISK_FINAL=$(getUsedDiskSpace)
  printInstalltime
}

# When the functions are loaded in the Keptn-in-a-box Shell this message will be printed out.
printInfo "Keptn-in-a-Box installation functions loaded in the current shell"
