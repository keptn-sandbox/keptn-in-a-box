#!/bin/bash +x
source ./utils.sh

FILE_IN="./activegate/k8monitoring.json"
FILE_OUT="./activegate/gen/k8monitoring.json"

readCredsFromFile
echo "Configure Kubernetes Monitoring with:"
echo "Dynatrace Tenant: $DT_TENANT"
echo "Dynatrace API Token: $DT_API_TOKEN"
echo "Dynatrace PaaS Token: $DT_PAAS_TOKEN"

configureAccountAndGetCredentials(){
    wget https://www.dynatrace.com/support/help/codefiles/kubernetes/kubernetes-monitoring-service-account.yaml
    kubectl apply -f kubernetes-monitoring-service-account.yaml
    echo "\This is the SSL API URI of the K8s cluster exposed via nginx ingress:"
    endpoint=$(kubectl get ing k8-api-ingress -o=jsonpath='{.spec.tls[0].hosts[0]}')
    # Name the connection
    title=$(echo $endpoint | sed 's~api\.kubernetes\.~~g' )
    # Add protocol 
    endpointUrl="https://${endpoint}"
    echo $endpointUrl
    echo "This is the Bearer Token for the K8s API:"
    authToken=$(kubectl get secret $(kubectl get sa dynatrace-monitoring -o jsonpath='{.secrets[0].name}' -n dynatrace) -o jsonpath='{.data.token}' -n dynatrace | base64 --decode)
    echo $authToken
}

replaceJson(){
    JSON=$(cat $FILE_IN)
    NJSON=$(echo $JSON | \
    jq --arg title "$title" '.label = $title' | \
    jq --arg endpointUrl "$endpointUrl" '.endpointUrl = $endpointUrl' | \
    jq --arg authToken "$authToken" '.authToken = $authToken')
    echo $NJSON > $FILE_OUT
}

connectClusterWithDynatrace(){
    DESTINATION="https://$DT_TENANT/api/config/v1/kubernetes/credentials/?api-token=$DT_API_TOKEN"
    curl -X POST -H 'Content-Type: application/json' -H 'cache-control: no-cache' -d @$FILE_OUT $DESTINATION
}

configureAccountAndGetCredentials
replaceJson
connectClusterWithDynatrace