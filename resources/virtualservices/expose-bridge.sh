#!/bin/bash
# Not needed anymore. after 0.7 Is not needed to add a VirtualService.
if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
else
    echo "No Domain has been passed, getting it from keptn-domain"
    DOMAIN=$(kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain})
fi

echo "About to create a VirtualService to the Keptn Bridge service to this domain $DOMAIN"
cat ./bridge.yaml | \
  sed 's~domain.placeholder~'"$DOMAIN"'~' > ./gen/bridge.yaml
  
kubectl apply -f ./gen/bridge.yaml