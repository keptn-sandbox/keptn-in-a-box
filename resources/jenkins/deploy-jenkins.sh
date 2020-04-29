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

echo "Installing Jenkins"
helm install stable/jenkins

cat ing-jenkins.yaml | \
  sed 's~domain.placeholder~'"$DOMAIN"'~' > ./gen/ing-jenkins.yaml

kubectl apply -f gen/ing-jenkins.yaml
