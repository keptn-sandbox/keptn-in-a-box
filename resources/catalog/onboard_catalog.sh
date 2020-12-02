#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "catalog" ]]; then
    # The context for this script needs to be in examples/onboarding-carts
    keptn create project keptnorders --shipyard=./shipyard.yaml
    # Onboarding - prepare  Keptn
    keptn onboard service catalog --project=keptnorders --chart=./catalog
    keptn onboard service customer --project=keptnorders --chart=./customer
    keptn onboard service frontend --project=keptnorders --chart=./frontend
    keptn onboard service order --project=keptnorders --chart=./order

    keptn add-resource --project=keptnorders --service=frontend --stage=staging --resource=frontend/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --service=frontend --stage=production --resource=frontend/quality-gates/simple_slo.yaml --resourceUri=slo.yaml

    keptn add-resource --project=keptnorders --service=order --stage=staging --resource=order/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --service=order --stage=production --resource=order/quality-gates/simple_slo.yaml --resourceUri=slo.yaml

    keptn add-resource --project=keptnorders --service=customer --stage=staging --resource=customer/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --service=customer --stage=production --resource=customer/quality-gates/simple_slo.yaml --resourceUri=slo.yaml

    keptn add-resource --project=keptnorders --service=catalog --stage=staging --resource=catalog/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --service=catalog --stage=production --resource=catalog/quality-gates/simple_slo.yaml --resourceUri=slo.yaml

    kubectl apply -f dynatrace-sli-config-keptnorders.yaml
    
    

else 
    echo "The helmcharts for catalog are not present"
fi 

