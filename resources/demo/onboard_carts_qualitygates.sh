#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "carts" ]]; then

    # The context for this script needs to be in examples/onboarding-carts
    echo "Adding the SLI for the Project to all Stages"
    keptn add-resource --project=sockshop --resource=sli-config-dynatrace.yaml --resourceUri=dynatrace/sli.yaml

    keptn configure monitoring dynatrace --project=sockshop

    echo "Setting up QualityGate to Staging"
    keptn add-resource --project=sockshop --stage=staging --service=carts --resource=slo-quality-gates.yaml --resourceUri=slo.yaml

else 
    echo "The helmcharts for carts are not present"
fi 

