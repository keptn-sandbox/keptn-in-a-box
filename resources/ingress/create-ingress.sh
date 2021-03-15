#!/bin/bash -x

if [ $# -eq 2 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    yaml=$2
    echo "Creating Ingress $yaml.yaml for $DOMAIN"
elif  [ $# -eq 1 ]; then
    yaml=$1
    echo "No Domain has been passed, getting it from the ConfigMap"
    DOMAIN=$(kubectl get configmap domain -n default -ojsonpath={.data.domain})
    echo "Domain: $DOMAIN"
    echo "Creating Ingress $yaml.yaml for $DOMAIN"
else
    echo "usage expose.sh DOMAIN yamlfilename"
    echo "usage expose.sh yamlfilename"
    exit
fi

cat $yaml.yaml | sed 's~domain.placeholder~'"$DOMAIN"'~' > ./gen/$yaml.yaml

kubectl apply -f gen/$yaml.yaml
