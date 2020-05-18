#!/bin/bash
## Ubuntu Server 20.04 LTS or 18.04 LTS  (HVM) for full functionality size 2xlarge 
## Microkubernetes 1.15, Keptn 6.1 with Istio 1.5, Helm 1.2, Docker, Registry, Dynatrace OneAgent and Dynatrace ActiveGate

## ----  Define variables ----
LOGFILE='/tmp/install.log'
chmod 775 $LOGFILE
pipe_log=true

# The installation will look for this file locally, if not found it will pull it form github.
FUNCTIONS_FILE='functions.sh'

# The user to run the commands from. Will be overwritten when executing this shell with sudo 
USER="ubuntu"

# create_workshop_user=true (will clone the home directory from USER and allow SSH login with text password )
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
KEPTN_VERSION=0.6.2
KEPTN_DT_SERVICE_VERSION=0.7.0
KEPTN_DT_SLI_SERVICE_VERSION=0.4.1
KEPTN_EXAMPLES_BRANCH=0.6.2
TEASER_IMAGE="shinojosa/nginxacm"
KEPTN_BRIDGE_IMAGE="keptn/bridge2:20200326.0744"
MICROK8S_CHANNEL="1.15/stable"
#Definitions for development purpouses
#KEPTN_IN_A_BOX_REPO="https://github.com/keptn-sandbox/keptn-in-a-box"
#FUNCTIONS_FILE_REPO="https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/master/functions.sh"
KEPTN_IN_A_BOX_REPO="https://github.com/sergiohinojosa/keptn-in-a-box"
FUNCTIONS_FILE_REPO="https://raw.githubusercontent.com/sergiohinojosa/keptn-in-a-box/dev/functions.sh"

## ----  Write all to the logfile ----
if [ "$pipe_log" = true ] ; then
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
    curl -o functions.sh $FUNCTIONS_FILE_REPO
fi

# Comfortable function for setting the sudo user.
if [ -n "${SUDO_USER}" ] ; then
  USER=$SUDO_USER
fi
echo "running sudo commands as $USER"

# Wrapper for runnig commands for the real owner and not as root
alias bashas="sudo -H -u ${USER} bash -c"
# Expand aliases for non-interactive shell
shopt -s expand_aliases

# --- Loading the functions in the current shell
source $FUNCTIONS_FILE

# --- Enable the installation Modules --- 
# Uncomment for installing the Default 
installationModulesDefault

# - Uncomment below for installing the minimal setup
#installationModulesMinimal

# - Uncomment below for installing all features
#installationModulesFull

# -- Override a module like for example verbose output of all commands
#verbose_mode=true
# -- or install cert manager 
#certmanager_install=true
#certmanager_enable=true

keptn_bridge_eap=false
# *** Do Installation 
doInstallation