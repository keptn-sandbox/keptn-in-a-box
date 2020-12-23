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

    keptn add-resource --project=keptnorders --stage=production --service=frontend --resource=frontend/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=production --service=order --resource=order/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=production --service=customer  --resource=customer/quality-gates/simple_slo.yaml --resourceUri=slo.yaml
    keptn add-resource --project=keptnorders --stage=production --service=catalog  --resource=catalog/quality-gates/simple_slo.yaml --resourceUri=slo.yaml

    

##
    keptn add-resource --project=keptnorders --service=frontend --stage=staging --resource=frontend/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=frontend --stage=staging --resource=frontend/jmeter/load.jmx --resourceUri=jmeter/load.jmx
    keptn add-resource --project=keptnorders --service=customer --stage=staging --resource=customer/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=customer --stage=staging --resource=customer/jmeter/load.jmx --resourceUri=jmeter/load.jmx
    keptn add-resource --project=keptnorders --service=catalog --stage=staging --resource=catalog/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=catalog --stage=staging --resource=catalog/jmeter/load.jmx --resourceUri=jmeter/load.jmx    
    keptn add-resource --project=keptnorders --service=order --stage=staging --resource=order/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=order --stage=staging --resource=order/jmeter/load.jmx --resourceUri=jmeter/load.jmx
 
    keptn add-resource --project=keptnorders --service=frontend --stage=production --resource=frontend/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=frontend --stage=production --resource=frontend/jmeter/load.jmx --resourceUri=jmeter/load.jmx
    keptn add-resource --project=keptnorders --service=customer --stage=production --resource=customer/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=customer --stage=production --resource=customer/jmeter/load.jmx --resourceUri=jmeter/load.jmx
    keptn add-resource --project=keptnorders --service=catalog --stage=production --resource=catalog/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=catalog --stage=production --resource=catalog/jmeter/load.jmx --resourceUri=jmeter/load.jmx
    keptn add-resource --project=keptnorders --service=order --stage=production --resource=order/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=order --stage=production --resource=order/jmeter/load.jmx --resourceUri=jmeter/load.jmx

else 
    echo "The helmcharts for catalog are not present"
fi 

