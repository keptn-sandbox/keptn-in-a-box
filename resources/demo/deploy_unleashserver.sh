#!/bin/bash -x

enableItemCache() {
    curl --request POST \
        --url ${UNLEASH_BASE_URL}/api/admin/features/ \
        --header "authorization: Basic ${UNLEASH_TOKEN}" \
        --header 'content-type: application/json' \
        --data '{
  "name": "EnableItemCache",
  "description": "carts",
  "enabled": false,
	"strategies": [
    {
      "name": "default",
      "parameters": {}
    }
  ]
}'
}

enablePromotion() {
    curl --request POST \
        --url ${UNLEASH_BASE_URL}/api/admin/features/ \
        --header "authorization: Basic ${UNLEASH_TOKEN}" \
        --header 'content-type: application/json' \
        --data '{
  "name": "EnablePromotion",
  "description": "carts",
  "enabled": false,
	"strategies": [
    {
      "name": "default",
      "parameters": {}
    }
  ]
}'
}

#If directory exists continue, otherwise exit
if [[ -d "unleash" ]]; then

    UNLEASH_TOKEN=$(echo -n keptn:keptn | base64)
    UNLEASH_BASE_URL=$(echo http://unleash.unleash-dev.$(kubectl -n keptn get ingress api-keptn-ingress -ojsonpath='{.spec.rules[0].host}'))

    # The context for this script needs to be in examples/unleash-server
    keptn create project unleash --shipyard=./shipyard.yaml
    keptn onboard service unleash-db --project=unleash --chart=./unleash-db
    keptn onboard service unleash --project=unleash --chart=./unleash
    keptn trigger delivery --project=unleash --service=unleash-db --image=postgres:10.4
    keptn trigger delivery --project=unleash --service=unleash --image=docker.io/keptnexamples/unleash:1.0.0

    # Configure Keptn
    kubectl -n keptn create secret generic unleash --from-literal="UNLEASH_SERVER_URL=http://unleash.unleash-dev/api" --from-literal="UNLEASH_USER=keptn" --from-literal="UNLEASH_TOKEN=keptn"


    kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/unleash-service/release-0.1.0/deploy/service.yaml
    
else
    echo "The helmcharts for unleash are not present"
fi


