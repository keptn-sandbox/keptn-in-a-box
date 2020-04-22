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

printf "\nRouting Istio via Nginx Ingress, create secret and certificates for the valid endpoints\n"

cat ingress-ssl-istio.yaml | \
  sed 's~domain.placeholder~'"$DOMAIN"'~' > ./gen/ingress-istio.yaml

# Deploy ingress with rules to domains and ingress-gateway. Create secret and certificate
kubectl apply -f gen/ingress-istio.yaml

# LetsEncrypt Process
printf " For observing the creation of the certificates: \n
kubectl describe clusterissuers.cert-manager.io -A
kubectl describe issuers.cert-manager.io -A
kubectl describe certificates.cert-manager.io -A
kubectl describe certificaterequests.cert-manager.io -A
kubectl describe challenges.acme.cert-manager.io -A
kubectl describe orders.acme.cert-manager.io -A
kubectl get events
"