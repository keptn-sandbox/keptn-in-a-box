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
YLW='\033[1;33m'
NC='\033[0m'

printenv DT_TENANTID
printenv DT_APITOKEN
printenv DT_PAASTOKEN
printenv DT_CERTMANAGER_EMAIL

echo -e "${YLW}Please enter the credentials as requested below: ${NC}"
read -e -i "${DT_TENANTID}" -p "Dynatrace Tenant ID ["${DT_TENANTID}"]: " iDTENVC
DTENVC="${iDTENVC:-${DT_TENANTID}}"
read -e -i "${DT_APITOKEN}" -p "Dynatrace API Token: ["${DT_APITOKEN}"]: " iDTAPIC
DTAPIC="${iDTAPIC:-${DT_APITOKEN}}"
read -e -i "${DT_PAASTOKEN}" -p "Dynatrace PaaS Token: ["${DT_PAASTOKEN}"]: " iDTPAAST
DTPAAST="${iDTPAAST:-${DT_PAASTOKEN}}"
read -e -i "${DT_CERTMANAGER_EMAIL}" -p "User Email ["${DT_CERTMANAGER_EMAIL}"]: " iDTUID
DTUID="${iDTUID:-${DT_CERTMANAGER_EMAIL}}"
echo ""

if [ -z "$DTENVC" ]
then
      exit 1
else
      DTENV=$DTENVC
      DTAPI=$DTAPIC
fi

echo ""
echo -e "${YLW}Please confirm all are correct: ${NC}"
echo "Dynatrace Tenant: $DTENV"
echo "Dynatrace API Token: $DTAPI"
echo "Dynatrace PaaS Token: $DTPAAST"
echo "User Name: $DTUID"
read -p "Is this all correct? (y/n) : " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]
then
   TENANTID=$DTENV
   APITOKEN=$DTAPI
   PAASTOKEN=$DTPAAST
   CERTMANAGER_EMAIL=$DTUID
else 
	exit 1   
fi

# while getopts t:p:a:e: flag
# do
#     case "${flag}" in
#         t) TENANTID=${OPTARG};;
#         p) PAASTOKEN=${OPTARG};;
#         a) APITOKEN=${OPTARG};;
#         e) CERTMANAGER_EMAIL=${OPTARG};;
#     esac
# done
(
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
# must include your quailified domain name
#TENANT="https://${TENANTID}.live.dynatrace.com"
#TENANT="https://${TENANTID}.sprint.dynatracelabs.com"
TENANT="https://${TENANTID}"

#PAASTOKEN=
#APITOKEN=
echo "tenant: $TENANT";

# Set your custom domain e.g for an internal machine like 192.168.0.1.nip.io
# So Keptn and all other services are routed and exposed properly via the Ingress Gateway
# if no DOMAIN is setted, the public IP of the machine will be converted to a magic nip.io domain 
# ---- Define your Domain ----
#DOMAIN="`curl http://checkip.amazonaws.com`.nip.io"
DOMAIN="kiab.pcjeffint.com"

# ---- The Email Account for the Certmanager ClusterIssuer with Let's encrypt ---- 
# ---- By not providing an Email and letting certificates get generated will end up in 
# face Email accounts Enabling certificates with lets encrypt and not changing for your email will end up in cert rate limits for: nip.io: see https://letsencrypt.org/docs/rate-limits/ 
#CERTMANAGER_EMAIL=

# ==================================================
#      ----- Functions Location -----              #
# ==================================================
# - Keptn in a Box release
KIAB_RELEASE="release-0.7.3.2"
# - Functions file location
FUNCTIONS_FILE_REPO="https://raw.githubusercontent.com/dthotday-performance/keptn-in-a-box/${KIAB_RELEASE}/functions.sh"

## ----  Write all output to the logfile ----
if [ "$pipe_log" = true ] ; then
  echo "your environment is being built. This will take several minutes...."
  echo "DO NOT exit or quit this session..."
  echo "Piping all output to logfile $LOGFILE"
  echo "open a new ssh session to view the logfile in real time...."
  echo "Type 'less +F $LOGFILE' for viewing the output of installation in realtime"
  echo ""
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
#installationBundleDemo

# - Comment out if only want to install the QualityGates functionality
#installationBundleKeptnQualityGates

# - Uncomment for installing Keptn-in-a-Box for Workshops
# installationBundleWorkshop

# - Uncomment below for installing all features
installationBundleAll

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
) &
