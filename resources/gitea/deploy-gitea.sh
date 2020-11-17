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

echo "create namespace for gitea"
kubectl create ns gitea

echo "Adding gitea charts"
helm repo add gitea-charts https://dl.gitea.io/charts/

echo "install gitea"
helm install gitea gitea-charts/gitea -f values.yaml --namespace gitea

# TODO create ingress from generated

# Create Token
curl -v --user keptn:keptn#R0cks -X POST "http://git.18-134-137-17.nip.io/api/v1/users/keptn/tokens" -H  "accept: application/json" -H "Content-Type: application/json" -d "{ \"name\": \"keptn-token\" }"

# Answer create token
{"id":1,"name":"keptn-token","sha1":"398b6d7d8ab902073f928f1bc2ff4bfac7b9848d","token_last_eight":"c7b9848d"}

# Create Repo with Token
curl -X POST "http://git.18-134-137-17.nip.io/api/v1/user/repos?access_token=398b6d7d8ab902073f928f1bc2ff4bfac7b9848d" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"auto_init\": false, \"default_branch\": \"master\", \"name\": \"sockshop\", \"private\": false}"

# Update Keptn Repo
keptn update project sockshop --git-user=keptn --git-token=398b6d7d8ab902073f928f1bc2ff4bfac7b9848d --git-remote-url=http://git.18-134-137-17.nip.io/gitea_admin/sockshop.git

# List projects via Keptn
# Update Keptn projects

# Documentation
# https://gitea.com/gitea/helm-chart/#configuration

# keptn
#KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)
#KEPTN_ENDPOINT="http://keptn.$DOMAIN/api"
#KEPTN_BRIDGE="http://keptn.$DOMAIN/bridge"

#sed -e 's~DOMAIN.placeholder~'"$DOMAIN"'~' \
#    -e 's~KEPTN_API_TOKEN.placeholder~'"$KEPTN_API_TOKEN"'~' \
#    -e 's~KEPTN_ENDPOINT.placeholder~'"$KEPTN_ENDPOINT"'~' \
#    -e 's~KEPTN_BRIDGE.placeholder~'"$KEPTN_BRIDGE"'~' \
#    helm-jenkins.yaml > gen/helm-jenkins.yaml

## TODO
# - create ingress with others?
# - create token
# - create repo


