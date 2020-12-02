#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "catalog" ]]; then
    # The context for this script needs to be in examples/onboarding-carts
    keptn create project catalog --shipyard=./shipyard.yaml
    # Onboarding - prepare  Keptn
    keptn onboard service catalog-service --project=catalog --chart=./catalog
    keptn onboard service customer-service --project=catalog --chart=./customer
    keptn onboard service front-end-service --project=catalog --chart=./frontend
    keptn onboard service order-service --project=catalog --chart=./order
    
    #keptn add-resource --project=catalog --stage=dev --service=carts --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    #keptn add-resource --project=catalog --stage=staging --service=carts --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx

    # Onboarding - prepare  Keptn
    #keptn onboard service carts-db --project=sockshop --chart=./carts-db --deployment-strategy=direct


else 
    echo "The helmcharts for catalog are not present"
fi 

