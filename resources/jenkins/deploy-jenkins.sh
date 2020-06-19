#!/bin/bash

if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    echo "Domain has been passed: $DOMAIN"
else
    echo "No Domain has been passed, getting it from public ip"
    export PUBLIC_IP=$(curl -s ifconfig.me) 
    PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
    export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"
    echo $DOMAIN
fi

echo "Create namespace jenkins"
kubectl create ns jenkins

echo "Replace Values for Ingress and Jenkins URL"

KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
KEPTN_ENDPOINT="https://api.keptn.$DOMAIN"
KEPTN_BRIDGE="http://bridge.keptn.$DOMAIN"

sed -e 's~DOMAIN.placeholder~'"$DOMAIN"'~' \
    -e 's~KEPTN_API_TOKEN.placeholder~'"$KEPTN_API_TOKEN"'~' \
    -e 's~KEPTN_ENDPOINT.placeholder~'"$KEPTN_ENDPOINT"'~' \
    -e 's~KEPTN_BRIDGE.placeholder~'"$KEPTN_BRIDGE"'~' \
    helm-jenkins.yaml > gen/helm-jenkins.yaml

sed 's~domain.placeholder~'"$DOMAIN"'~' ing-jenkins.yaml > gen/ing-jenkins.yaml

helm init

helm repo update

echo "Installing Jenkins via Helm"
helm install stable/jenkins -n jenkins -f gen/helm-jenkins.yaml

echo "Create Jenkins Ingress"
kubectl apply -f gen/ing-jenkins.yaml
