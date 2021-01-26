#!/bin/bash

# 
# Use this script to reset the environment
#
KEPTN_IN_A_BOX_REPO="https://github.com/dthotday-performance/keptn-in-a-box.git"
KIAB_RELEASE="release-0.7.3.1"
KIAB_FILE_REPO="https://raw.githubusercontent.com/dthotday-performance/keptn-in-a-box/${KIAB_RELEASE}/keptn-in-a-box.sh"

sudo snap remove microk8s --purge
cd /opt/dynatrace/gateway
sudo ./uninstall.sh
cd ~
sudo rm -rf *
cd ~
rm -rf .keptn
rm -rf .kube
curl -O $KIAB_FILE_REPO
chmod +x keptn-in-a-box.sh
echo "Reset Complete..."