#!/bin/bash
source ../dynatrace/utils.sh

cp ~/keptn-in-a-box/resources/dynatrace/creds_dt.json ~/keptn-in-a-box/resources/jenkins/creds_dt.json

if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    echo "Domain has been passed: $DOMAIN"
else
    echo "No Domain has been passed, getting it from Keptn"
    DOMAIN=$(kubectl get ing -n default homepage-ingress -o=jsonpath='{.spec.tls[0].hosts[0]}')
    echo "KIAB Domain: $DOMAIN"
fi

echo "Create namespace jenkins"
kubectl create ns jenkins

echo "Replace Values for Ingress and Jenkins URL"

KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
KEPTN_ENDPOINT="http://keptn.$DOMAIN/api"
KEPTN_BRIDGE="http://keptn.$DOMAIN/bridge"

readCredsFromFile
printVariables

DT_TENANT=$DT_TENANT
DT_API_TOKEN=$DT_API_TOKEN
DT_PAAS_TOKEN=$DT_PAAS_TOKEN

sed -e 's~DOMAIN.placeholder~'"$DOMAIN"'~' \
    -e 's~KEPTN_API_TOKEN.placeholder~'"$KEPTN_API_TOKEN"'~' \
    -e 's~KEPTN_ENDPOINT.placeholder~'"$KEPTN_ENDPOINT"'~' \
    -e 's~KEPTN_BRIDGE.placeholder~'"$KEPTN_BRIDGE"'~' \
    -e 's~DT_TENANT.placeholder~'"$DT_TENANT"'~' \
    -e 's~DT_API_TOKEN.placeholder~'"$DT_API_TOKEN"'~' \
    helm-jenkins.yaml > gen/helm-jenkins.yaml

echo "Ensure Helm Jenkins repo is present"
helm repo add jenkins https://charts.jenkins.io

echo "Installing Jenkins via Helm"
helm install jenkins jenkins/jenkins -f gen/helm-jenkins.yaml --version 2.19.0
