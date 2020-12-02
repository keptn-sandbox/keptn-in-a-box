#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "catalog" ]]; then
    # The context for this script needs to be in examples/onboarding-carts
    keptn create project catalog --shipyard=./shipyard.yaml
    # Onboarding - prepare  Keptn
    keptn onboard service catalog-service --project=catalog --chart=./catalog
    keptn onboard service customer-service --project=catalog --chart=./customer
    keptn onboard service front-end --project=catalog --chart=./frontend
    keptn onboard service order-service --project=catalog --chart=./order
    
    keptn add-resource --project=catalog --stage=dev --service=front-end --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=catalog --stage=staging --service=front-end --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx

else 
    echo "The helmcharts for catalog are not present"
fi 

