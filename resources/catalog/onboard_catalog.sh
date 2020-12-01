#!/bin/bash -x

#If directory exists continue, otherwise exit
#if [[ -d "k8" ]]; then
    # The context for this script needs to be in examples/onboarding-carts
    keptn create project catalog --shipyard=./shipyard.yaml
    # Onboarding - prepare  Keptn
    #keptn onboard service catalog --project=catalog --chart=./carts
    
    keptn onboard service --project=catalog --values=./keptn-onboarding/values_front-end.yaml
    keptn onboard service --project=catalog --values=./keptn-onboarding/values_customer-service.yaml
    keptn onboard service --project=catalog --values=./keptn-onboarding/values_order-service.yaml
    keptn onboard service --project=catalog --values=./keptn-onboarding/values_catalog-service.yaml
    
    #keptn add-resource --project=catalog --stage=dev --service=carts --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    #keptn add-resource --project=catalog --stage=staging --service=carts --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx

    # Onboarding - prepare  Keptn
    #keptn onboard service carts-db --project=sockshop --chart=./carts-db --deployment-strategy=direct


#else 
#    echo "The helmcharts for catalog are not present"
#fi 

