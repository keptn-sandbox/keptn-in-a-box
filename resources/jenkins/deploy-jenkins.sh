#!/bin/bash -x

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
sed 's~domain.placeholder~'"$DOMAIN"'~' helm-jenkins.yaml > gen/helm-jenkins.yaml
sed 's~domain.placeholder~'"$DOMAIN"'~' ing-jenkins.yaml > gen/ing-jenkins.yaml

echo "Installing Jenkins via Helm"
helm install stable/jenkins -n jenkins -f gen/helm-jenkins.yaml

echo "Create Jenkins Ingress"
kubectl apply -f gen/ing-jenkins.yaml
