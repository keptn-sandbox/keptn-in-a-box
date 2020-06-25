#!/bin/bash
# =========================================================
#      -------- Keptn-in-a-Box -------                    #
# Script for installing Keptn in an Ubuntu Server LTS     #
# (20 or 18). Installed components are but not limited to:#
# Microk8s, Keptn, Istio, Helm, Docker, Docker Registry   #
# Jenkins, Dynatrace OneAgent, Dynatrace ActiveGate,      #
# Unleash, KeptnExamples                                  #
#                                                         #
# This file is the main installation process. In here you #
# define the installationBundles and its functions.       #
# The definition of variables and different versions are  #
# defined here.                                           #
#                                                         #
# 'functions.sh' is where the functions are defined and   #
# will be loaded into this shell upon execution.          #
# controlled via boolean flags.                           #
#                                                         #
# An installationBundle contains a set of multiple ins-   #
# tallation functions.                                    #
# =========================================================

# ==================================================
#      ----- Variables Definitions -----           #
# ==================================================
LOGFILE='/tmp/install.log'
touch $LOGFILE
chmod 775 $LOGFILE
pipe_log=true

# - The installation will look for this file locally, if not found it will pull it form github.
FUNCTIONS_FILE='functions.sh'

# ---- Workshop User  ---- 
# The flag 'create_workshop_user'=true is per default set to false. If it's set to to it'll clone the home directory from USER and allow SSH login with the given text password )
NEWUSER="student"
NEWPWD="secr3t"

# ---- Define Dynatrace Environment ---- 
# Sample: https://{your-domain}/e/{your-environment-id} for managed or https://{your-environment-id}.live.dynatrace.com for SaaS
TENANT=
PAASTOKEN=
APITOKEN=

# Set your custom domain e.g for an internal machine like 192.168.0.1.nip.io
# So Keptn and all other services are routed and exposed properly via the Ingress Gateway
# if no DOMAIN is setted, the public IP of the machine will be converted to a magic nip.io domain 
# ---- Define your Domain ----   
DOMAIN=

# ---- The Email Account for the Certmanager ClusterIssuer with Let's encrypt ---- 
# ---- By not providing an Email and letting certificates get generated will end up in 
# face Email accounts Enabling certificates with lets encrypt and not changing for your email will end up in cert rate limits for: nip.io: see https://letsencrypt.org/docs/rate-limits/ 
CERTMANAGER_EMAIL=

# ==================================================
#      ----- Functions Location -----                #
# ==================================================
FUNCTIONS_FILE_REPO="https://raw.githubusercontent.com/keptn-sandbox/keptn-in-a-box/master/functions.sh"


## ----  Write all output to the logfile ----
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
    echo "The functions file $FUNCTIONS_FILE exists locally, loading functions from it. (dev)"
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

# ==================================================
#      ----- Override Components Versions -----    #
# ==================================================
#MICROK8S_CHANNEL="1.15/stable"
#KEPTN_IN_A_BOX_DIR="~/keptn-in-a-box"
#KEPTN_EXAMPLES_DIR="~/examples"
#KEPTN_IN_A_BOX_REPO="https://github.com/keptn-sandbox/keptn-in-a-box"
# ==================================================
#    ----- Select your installation Bundle -----   #
# ==================================================
# Uncomment for installing only Keptn 
# installationBundleKeptnOnly

# - Comment out if selecting another bundle
installationBundleDemo

# - Comment out if only want to install the QualityGates functionality
#installationBundleKeptnQualityGates

# - Uncomment for installing Keptn-in-a-Box for Workshops
# installationBundleWorkshop

# - Uncomment below for installing all features
#installationBundleAll

# - Uncomment below for installing a PerformanceAsAService Box
#installationBundlePerformanceAsAService

# ==================================================
# ---- Enable or Disable specific functions -----  #
# ==================================================
# -- Override a module like for example verbose output of all commands
#verbose_mode=false

# -- or install cert manager 
#certmanager_install=true
#certmanager_enable=true
#create_workshop_user=true

# ==================================================
#  ----- Call the Installation Function -----      #
# ==================================================
doInstallation
