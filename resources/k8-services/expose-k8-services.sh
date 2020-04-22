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

printf "\nSkip Login in K8 Dashboard \n"
kubectl -n kube-system patch deployments kubernetes-dashboard --patch "$(cat skip-login-in-k8-dashboard-patch.yaml)"

printf "\nExpose Kubernetes API, Grafana & Dashboard \n"
cat k8-svc-ingress.yaml | \
  sed 's~domain.placeholder~'"$DOMAIN"'~' > ./gen/k8-svc-ingress.yaml

# Deploy ingress with rules to domains and ingress-gateway. Create secret and certificate
kubectl apply -f gen/k8-svc-ingress.yaml