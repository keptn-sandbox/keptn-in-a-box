#!/bin/bash
if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    echo "Domain has been passed: $DOMAIN"
else
    echo "No Domain has been passed, getting it from the Home-Ingress"
    DOMAIN=$(kubectl get ing -n default homepage-ingress -o=jsonpath='{.spec.tls[0].hosts[0]}')
    echo "Domain: $DOMAIN"
fi

# Load git vars
source ./gitea-vars.sh $DOMAIN

echo "create namespace for git"
kubectl create ns git

sed -e 's~domain.placeholder~'"$DOMAIN"'~' \
    -e 's~GIT_USER.placeholder~'"$GIT_USER"'~' \
    -e 's~GIT_PASSWORD.placeholder~'"$GIT_PASSWORD"'~' \
    helm-gitea.yaml > gen/helm-gitea.yaml

echo "install gitea via Helmchart"
helm install gitea gitea-charts/gitea -f gen/helm-gitea.yaml --namespace git