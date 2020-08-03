#!/bin/bash
source ./utils.sh


deploy_operator () {
export DT_API_TOKEN=$DT_API_TOKEN
export DT_PAAS_TOKEN=$DT_PAAS_TOKEN
export DT_API_URL=https://$DT_TENANT/api

# Install the operator
echo "Creating dynatrace K8s namespace"
kubectl create namespace dynatrace
echo "Downloading the latest oneagent operator release (definition) (-L for follow redirect"
curl -L -o kubernetes.yaml https://github.com/Dynatrace/dynatrace-oneagent-operator/releases/latest/download/kubernetes.yaml
kubectl create -f kubernetes.yaml
#kubectl -n dynatrace logs -f deployment/dynatrace-oneagent-operator
kubectl -n dynatrace create secret generic oneagent --from-literal="apiToken=$DT_API_TOKEN" --from-literal="paasToken=$DT_PAAS_TOKEN"

curl -o cr.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/master/deploy/cr.yaml
sed -i "s+apiUrl: https://ENVIRONMENTID.live.dynatrace.com/api+apiUrl: $DT_API_URL+g" cr.yaml
kubectl create -f cr.yaml
}

echo "Deploying the oneagent via operator..."
readCredsFromFile
printVariables
echo "Are the values correct? Continue? [y/n]"
read REPLY
case "$REPLY" in
    [yY]) 
        deploy_operator
        ;;
    *)
        echo "Ok then run ./save-credentials.sh to set the new credentials"
        exit
        ;;
esac
exit
