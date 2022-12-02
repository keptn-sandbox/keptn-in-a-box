#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "carts" ]]; then

    # TODO Install GIT before and create the repo of the project. Use the helper functions :) can actually navogate from here. (nested but does the job)

    # read tokens

    # create repo

    # set $KEPTN_PROJECT

    # The context for this script needs to be in examples/onboarding-carts
    keptn create project sockshop --shipyard=./shipyard.yaml --git-user=$GIT_USER --git-token=$API_TOKEN --git-remote-url=$GIT_SERVER/$GIT_USER/$KEPTN_PROJECT.git
    # Onboarding - prepare  Keptn
    keptn create service carts --project=sockshop
    keptn add-resource --project=sockshop --service=carts --all-stages --resource=./carts.tgz --resourceUri=helm/carts.tgz

    keptn add-resource --project=sockshop --stage=dev --service=carts --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=sockshop --stage=staging --service=carts --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx

    # Onboarding - prepare  Keptn
    keptn create service carts-db --project=sockshop
    keptn add-resource --project=sockshop --service=carts-db --all-stages --resource=./carts-db.tgz --resourceUri=helm/carts-db.tgz


else 
    echo "The helmcharts for carts are not present"
fi 

