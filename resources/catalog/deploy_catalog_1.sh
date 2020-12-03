#!/bin/bash -x

# Trigger the deployment
keptn send event new-artifact --project=keptnorders --service=catalog --image=docker.io/dtdemos/dt-orders-catalog-service --tag=1

# Trigger the deployment
keptn send event new-artifact --project=keptnorders --service=order --image=docker.io/dtdemos/dt-orders-order-service --tag=1

# Trigger the deployment
keptn send event new-artifact --project=keptnorders --service=frontend --image=docker.io/dtdemos/dt-orders-frontend --tag=1

# Trigger the deployment
keptn send event new-artifact --project=keptnorders --service=customer --image=docker.io/dtdemos/dt-orders-customer-service --tag=1
