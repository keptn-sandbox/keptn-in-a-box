#!/bin/bash -x


#If directory exists continue, otherwise exit
if [[ -d "unleash" ]]; then

    # The context for this script needs to be in examples/unleash-server
    keptn create project unleash --shipyard=./shipyard.yaml

    keptn create service unleash-db --project=unleash 
    keptn add-resource --project=unleash --service=unleash-db --all-stages --resource=./unleash-db.tgz --resourceUri=helm/unleash-db.tgz

    keptn create service unleash --project=unleash
    keptn add-resource --project=unleash --service=unleash --all-stages --resource=./unleash.tgz --resourceUri=helm/unleash.tgz

    keptn trigger delivery --project=unleash --service=unleash-db --image=postgres:10.4 

    keptn trigger delivery --project=unleash --service=unleash --image=docker.io/keptnexamples/unleash:1.0.0

    # Configure Keptn
    kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/unleash-service/release-0.1.0/deploy/service.yaml
    
else
    echo "The helmcharts for unleash are not present"
fi


