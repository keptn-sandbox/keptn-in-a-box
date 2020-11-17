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

#Default values
GIT_USER="keptn"
GIT_PASSWORD="keptn#R0cks"
GIT_SERVER="http://git.$DOMAIN"

# static vars
GIT_TOKEN="keptn-token"
TOKEN_FILE=$GIT_TOKEN.json

echo "Username: $GIT_USER"
echo "Password: $GIT_PASSWORD"
echo "GIT-Server: $GIT_SERVER" 



