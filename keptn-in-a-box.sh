#!/bin/bash
## Ubuntu Server 18.04 LTS (HVM) for full functionality sice 2xlarge 
## Microkubernetes 1.15, Keptn 6.1 with Istio 1.5, Helm 1.2, Docker, Registry, OneAgent and ActiveGate

## ----  Define variables ----
LOGFILE='/tmp/install.log'
chmod 775 $LOGFILE
pipe_log=true

# The installation will look for this file locally, if not found it will pull it form github.
FUNCTIONS_FILE='functions.sh'

USER="ubuntu"
NEWPWD="dynatrace"
NEWUSER="dynatrace"

# ****  Define Dynatrace Environment **** 
# Sample: https://{your-domain}/e/{your-environment-id} for managed or https://{your-environment-id}.live.dynatrace.com for SaaS
TENANT=
PAASTOKEN=
APITOKEN=

# Set your custom domain e.g for an internal machine like 192.168.0.1.nip.io
# So Keptn and all other services are routed and exposed properly via the Ingress Gateway
# if no DOMAIN is setted, the public IP of the machine will be converted to a magic nip.io domain   
DOMAIN=

# **** Installation Versions **** 
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

## ----  Write all to the logfile ----
if [ "$pipe_log" = true ]; then
  echo "Piping all output to logfile $LOGFILE"
  echo "Type 'less +F $LOGFILE' for viewing the output of installation on realtime"
  echo "If you did not send the job to the background, type \"CTRL + Z\" and \"bg\""
  echo "CTRL + Z (for pausing this job)"
  echo "then"
  echo "bg (for resuming back this job and send it to the background)"
  # Saves file descriptors so they can be restored to whatever they were before redirection or used 
  # themselves to output to whatever they were before the following redirect.
  exec 3>&1 4>&2
  # Restore file descriptors for particular signals. Not generally necessary since they should be restored when the sub-shell exits.
  trap 'exec 2>&4 1>&3' 0 1 2 3
  # Redirect stdout to file log.out then redirect stderr to stdout. Note that the order is important when you 
  # want them going to the same file. stdout must be redirected before stderr is redirected to stdout.
  exec 1>$LOGFILE 2>&1
else
  echo "Not piping stdout stderr to the logfile, writing the installation to the console"
fi

# Load functions after defining the variables & versions
if [ -f "$FUNCTIONS_FILE" ]; then
    echo "The functions file $FUNCTIONS_FILE exists locally, loading functions from it."
else 
    echo "The functions file $FUNCTIONS_FILE does not exist, getting it from github."
    curl -o functions.sh https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/functions/functions.sh
fi
# --- Loading the functions in the current shell
source $FUNCTIONS_FILE


# --- Enable the installation Modules --- 
installationModulesDefault

#installationModulesMinimal

#installationModulesFull

# -- Override a module like for example verbose output of all commands
#verbose_mode=true

# -- or install cert manager 
#certmanager_install=true
#certmanager_enable=true

# do Installation
doInstallation