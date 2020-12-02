#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "catalog" ]]; then

    # The context for this script needs to be in examples/onboarding-carts
    echo "Adding the SLI for the Project to all Stages"
    keptn add-resource --project=catalog --resource=sli-config-dynatrace.yaml --resourceUri=dynatrace/sli.yaml

    keptn configure monitoring dynatrace --project=catalog

    echo "Setting up QualityGate to Staging"
    keptn add-resource --project=catalog --stage=staging --service=order-service --resource=slo-quality-gates.yaml --resourceUri=slo.yaml

else 
    echo "The helmcharts for catalog are not present"
fi 

