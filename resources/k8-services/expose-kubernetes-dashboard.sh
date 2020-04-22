#!/bin/bash -x

if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    echo $DOMAIN
else
    echo "No Domain has been passed, getting it from public ip"
    export PUBLIC_IP=$(curl -s ifconfig.me) 
    PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
    export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"
    echo $DOMAIN
fi

echo "Expose Kubernetes API"
cat ing-kubernetes-dashboard.yaml | \
  sed 's~domain.placeholder~'"$DOMAIN"'~' > ./gen/ing-kubernetes-dashboard.yaml

# Deploy ingress with rules to domains and ingress-gateway.
kubectl apply -f gen/ing-kubernetes-dashboard.yaml