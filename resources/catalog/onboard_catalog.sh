#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "catalog" ]]; then
    # The context for this script needs to be in examples/onboarding-carts
    keptn create project keptnorders --shipyard=./shipyard.yaml
    # Onboarding - prepare  Keptn
    keptn onboard service order --project=keptnorders --chart=./order
    keptn onboard service catalog --project=keptnorders --chart=./catalog
    keptn onboard service customer --project=keptnorders --chart=./customer
    keptn onboard service frontend --project=keptnorders --chart=./frontend
    
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

