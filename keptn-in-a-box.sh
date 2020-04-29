#!/bin/bash
## Ubuntu Server 18.04 LTS (HVM) for full functionality sice 2xlarge 
## Microkubernetes 1.15, Keptn 6.1 with Istio 1.5, Helm 1.2, Docker, Registry, OneAgent and ActiveGate

## ----  Define variables ----
LOGFILE='/tmp/install.log'
chmod 775 $LOGFILE
USER="ubuntu"
NEWPWD="dynatrace"
NEWUSER="dynatrace"

# Define Dynatrace Environment
# Sample: https://{your-domain}/e/{your-environment-id} for managed or https://{your-environment-id}.live.dynatrace.com for SaaS
TENANT=
PAASTOKEN=
APITOKEN=

# Versions
ISTIO_VERSION=1.5.1
HELM_VERSION=2.12.3
CERTMANAGER_VERSION=0.14.0
KEPTN_VERSION=0.6.1
KEPTN_DT_SERVICE_VERSION=0.6.2
KEPTN_DT_SLI_SERVICE_VERSION=0.3.1
KEPTN_EXAMPLES_BRANCH=0.6.1
TEASER_IMAGE="shinojosa/nginxacm"
KEPTN_BRIDGE_IMAGE="keptn/bridge2:20200326.0744"
MICROK8S_CHANNEL="1.15/stable"

# Set installation modules
verbose_mode=false
update_ubuntu=true
docker_install=true
microk8s_install=true
setup_proaliases=true
setup_magicdomain_publicip=true
enable_k8dashboard=true
enable_registry=true
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
create_workshop_user=true

## ----  Write all to the logfile ----
# Saves file descriptors so they can be restored to whatever they were before redirection or used 
# themselves to output to whatever they were before the following redirect.
#exec 3>&1 4>&2

# Restore file descriptors for particular signals. Not generally necessary since they should be restored when the sub-shell exits.
#trap 'exec 2>&4 1>&3' 0 1 2 3

# Redirect stdout to file log.out then redirect stderr to stdout. Note that the order is important when you 
# want them going to the same file. stdout must be redirected before stderr is redirected to stdout.
#exec 1>$LOGFILE 2>&1

SECONDS=0

USER="shi"
# Wrapper for runnig commands for the real owner and not as root
alias bashas="sudo -H -u ${USER} bash -c"
# Expand aliases for non-interactive shell
shopt -s expand_aliases

echo ""
echo "***** Init Installation at  `date` by user `whoami` ****"
echo "***** Setting up Microk8s (SingleNode K8s Dev Cluster) with Keptn ****"
echo ""

# Load the functions. The variables should all be defined
source ./functions.sh


dynatracePrintCredentials
bashas "echo \"hello\" whoami"
read -p "Want to continue? (y/n) : " -n 1 -r

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