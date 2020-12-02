#!/bin/bash -x

# Trigger the deployment
keptn send event new-artifact --project=keptnorders --service=catalog --image=dtdemos/dt-orders-catalog-service --tag=1

# Trigger the deployment
keptn send event new-artifact --project=keptnorders --service=order --image=dtdemos/dt-orders-order-services --tag=1

# Trigger the deployment
keptn send event new-artifact --project=keptnorders --service=frontend --image=dtdemos/dt-orders-frontend --tag=1

# Trigger the deployment
keptn send event new-artifact --project=keptnorders --service=customer --image=dtdemos/dt-orders-customer-service --tag=1
