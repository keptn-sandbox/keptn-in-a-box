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
  
    
else 
    echo "The helmcharts for catalog are not present"
fi 

