#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "catalog" ]]; then

    # The context for this script needs to be in examples/onboarding-carts
    echo "Adding the SLI for the Project to all Stages"
    keptn add-resource --project=keptnorders --resource=dynatrace-sli-config-keptnorders.yaml --resourceUri=dynatrace/sli.yaml
      
    kubectl apply -f dynatrace-sli-config-keptnorders.yaml
    
    keptn configure monitoring dynatrace --project=keptnorders

    echo "Setting up QualityGate to Staging"
    keptn add-resource --project=keptnorders --stage=staging --service=order --resource=order/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=staging --service=catalog --resource=catalog/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=staging --service=customer --resource=customer/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=staging --service=frontend --resource=frontend/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    echo "Setting up QualityGate to Production"
    keptn add-resource --project=keptnorders --stage=production --service=frontend --resource=frontend/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=production --service=order --resource=order/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=production --service=customer  --resource=customer/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=production --service=catalog  --resource=catalog/quality-gates/simple_slo.yaml --resourceUri=slo.yaml

else 
    echo "The helmcharts for catalog are not present"
fi 

