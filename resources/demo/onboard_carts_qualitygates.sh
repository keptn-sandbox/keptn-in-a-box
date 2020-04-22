#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "carts" ]]; then
    # The context for this script needs to be in examples/onboarding-carts
    keptn add-resource --project=sockshop --stage=staging --service=carts --resource=slo-quality-gates.yaml --resourceUri=slo.yaml

    keptn configure monitoring dynatrace --project=sockshop

    keptn add-resource --project=sockshop --stage=staging --service=carts --resource=sli-config-dynatrace.yaml --resourceUri=dynatrace/sli.yaml
else 
    echo "The helmcharts for carts are not present"
fi 

