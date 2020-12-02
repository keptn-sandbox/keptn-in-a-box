#!/bin/bash -x

# Trigger the deployment
keptn send event new-artifact --project=catalog --service=catalog-service --image=docker.io/dtdemos/dt-orders-catalog-service --tag=1

# Trigger the deployment
keptn send event new-artifact --project=catalog --service=order-service --image=docker.io/dtdemos/dt-orders-order-services --tag=1

# Trigger the deployment
keptn send event new-artifact --project=catalog --service=front-end --image=docker.io/dtdemos/dt-orders-frontend --tag=1

# Trigger the deployment
keptn send event new-artifact --project=catalog --service=customer-service --image=docker.io/dtdemos/dt-orders-customer-service --tag=1
