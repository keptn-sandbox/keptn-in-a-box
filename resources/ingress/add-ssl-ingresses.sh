#!/bin/bash -x

if [ $# -eq 2 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    yaml=$2
    echo "Creating Ingress $yaml.yaml for $DOMAIN"
else
    echo "usage expose.sh DOMAIN yamlfilename"
    #TODO Improve with kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain}
    exit
fi

cat $yaml.yaml | sed 's~domain.placeholder~'"$DOMAIN"'~' > ./gen/$yaml.yaml

kubectl apply -f gen/$yaml.yaml
