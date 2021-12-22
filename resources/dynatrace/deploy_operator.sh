#!/bin/bash
source ./utils.sh

deploy_operator() {
    export DT_API_TOKEN=$DT_API_TOKEN
    export DT_PAAS_TOKEN=$DT_PAAS_TOKEN
    export DT_API_URL=https://$DT_TENANT/api

    # Install the operator
    echo "Installing the Operator and connecting the K8s API"
    sh ./install.sh  --api-url "$DT_API_URL" --api-token "$DT_API_TOKEN" --paas-token "$DT_PAAS_TOKEN" --skip-ssl-verification --cluster-name "keptn-in-a-box"
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
