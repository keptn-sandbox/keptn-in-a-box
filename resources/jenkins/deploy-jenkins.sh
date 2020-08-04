#!/bin/bash

if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    echo "Domain has been passed: $DOMAIN"
else
    echo "No Domain has been passed, getting it from Keptn"
    DOMAIN=$(kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain})
     echo "Keptn Domain: $DOMAIN"
fi

echo "Create namespace jenkins"
kubectl create ns jenkins

echo "Replace Values for Ingress and Jenkins URL"

KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
KEPTN_ENDPOINT="http://keptn.$DOMAIN/api"
KEPTN_BRIDGE="http://keptn.$DOMAIN/bridge"

sed -e 's~DOMAIN.placeholder~'"$DOMAIN"'~' \
    -e 's~KEPTN_API_TOKEN.placeholder~'"$KEPTN_API_TOKEN"'~' \
    -e 's~KEPTN_ENDPOINT.placeholder~'"$KEPTN_ENDPOINT"'~' \
    -e 's~KEPTN_BRIDGE.placeholder~'"$KEPTN_BRIDGE"'~' \
    helm-jenkins.yaml > gen/helm-jenkins.yaml

echo "Installing Jenkins via Helm"
helm install jenkins stable/jenkins -f gen/helm-jenkins.yaml