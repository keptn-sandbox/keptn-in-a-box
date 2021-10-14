#!/bin/bash

if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    echo "Domain has been passed: $DOMAIN"
else
    echo "No Domain has been passed, getting it from the ConfigMap"
    DOMAIN=$(kubectl get configmap domain -n default -ojsonpath={.data.domain})
    echo "Domain: $DOMAIN"
fi

echo "Create namespace jenkins"
kubectl create ns jenkins

echo "Replace Values for Ingress and Jenkins URL"

DT_TENANT=$(kubectl get secret dynatrace -n keptn -ojsonpath={.data.DT_TENANT} | base64 --decode)
DT_API_TOKEN=$(kubectl get secret dynatrace -n keptn -ojsonpath={.data.DT_API_TOKEN} | base64 --decode)
KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
KEPTN_ENDPOINT="http://keptn.$DOMAIN/api"
KEPTN_BRIDGE="http://keptn.$DOMAIN/bridge"

sed -e 's~DOMAIN.placeholder~'"$DOMAIN"'~' \
    -e 's~KEPTN_API_TOKEN.placeholder~'"$KEPTN_API_TOKEN"'~' \
    -e 's~KEPTN_ENDPOINT.placeholder~'"$KEPTN_ENDPOINT"'~' \
    -e 's~KEPTN_BRIDGE.placeholder~'"$KEPTN_BRIDGE"'~' \
    -e 's~DT_TENANT.placeholder~'"$DT_TENANT"'~' \
    -e 's~DT_API_TOKEN.placeholder~'"$DT_API_TOKEN"'~' \
    helm-jenkins.yaml > gen/helm-jenkins.yaml

echo "Installing Jenkins via Helm"
helm install jenkins jenkins/jenkins -f gen/helm-jenkins.yaml --version 2.19.0