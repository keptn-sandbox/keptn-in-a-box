#!/bin/bash -x

#If directory exists continue, otherwise exit
if [[ -d "catalog" ]]; then
    
    # The context for this script needs to be in examples/onboarding-carts
    echo "load shipyard.yaml"
    keptn create project keptnorders --shipyard=./shipyard.yaml
    
    # Onboarding - prepare  Keptn
    echo "onboard services"
    keptn onboard service order --project=keptnorders --chart=./order
    keptn onboard service catalog --project=keptnorders --chart=./catalog
    keptn onboard service customer --project=keptnorders --chart=./customer
    keptn onboard service frontend --project=keptnorders --chart=./frontend
    
    # add jmeter resources for staging
    echo "load for project"
    #keptn add-resource --project=keptnorders --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    #keptn add-resource --project=keptnorders --resource=jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    echo "load service level jmeter scripts-staging"
    keptn add-resource --project=keptnorders --service=frontend --stage=staging --resource=frontend/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=frontend --stage=staging --resource=frontend/jmeter/load.jmx --resourceUri=jmeter/load.jmx
    
    keptn add-resource --project=keptnorders --service=customer --stage=staging --resource=customer/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=customer --stage=staging --resource=customer/jmeter/load.jmx --resourceUri=jmeter/load.jmx
    
    keptn add-resource --project=keptnorders --service=catalog --stage=staging --resource=catalog/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=catalog --stage=staging --resource=catalog/jmeter/load.jmx --resourceUri=jmeter/load.jmx    
    
    keptn add-resource --project=keptnorders --service=order --stage=staging --resource=order/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=order --stage=staging --resource=order/jmeter/load.jmx --resourceUri=jmeter/load.jmx    
    
    # add jmeter resources for production
    echo "load service level jmeter scripts-production"
    keptn add-resource --project=keptnorders --service=frontend --stage=production --resource=frontend/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=frontend --stage=production --resource=frontend/jmeter/load.jmx --resourceUri=jmeter/load.jmx
    
    keptn add-resource --project=keptnorders --service=customer --stage=production --resource=customer/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=customer --stage=production --resource=customer/jmeter/load.jmx --resourceUri=jmeter/load.jmx
    
    keptn add-resource --project=keptnorders --service=catalog --stage=production --resource=catalog/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=catalog --stage=production --resource=catalog/jmeter/load.jmx --resourceUri=jmeter/load.jmx
    
    keptn add-resource --project=keptnorders --service=order --stage=production --resource=order/jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
    keptn add-resource --project=keptnorders --service=order --stage=production --resource=order/jmeter/load.jmx --resourceUri=jmeter/load.jmx
    
    # add jmeter config for staging
    echo "load jmeter.conf.yaml"
    keptn add-resource --project=keptnorders --service=order --stage=staging --resource=order/jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=keptnorders --service=customer --stage=staging --resource=customer/jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=keptnorders --service=catalog --stage=staging --resource=catalog/jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=keptnorders --service=frontend --stage=staging --resource=frontend/jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    # add jmeter config for production
    keptn add-resource --project=keptnorders --service=order --stage=production --resource=order/jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=keptnorders --service=customer --stage=production --resource=customer/jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=keptnorders --service=catalog --stage=production --resource=catalog/jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
    keptn add-resource --project=keptnorders --service=frontend --stage=production --resource=frontend/jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml    
else 
    echo "The helmcharts for catalog are not present"
fi 

