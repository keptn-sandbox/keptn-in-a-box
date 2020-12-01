#!/bin/bash -x

# Trigger the deployment
keptn send event new-artifact --project=catalog --service=catalog-service --image=docker.io/dtdemos/dt-orders-catalog-service --tag=1

# Trigger the deployment
keptn send event new-artifact --project=catalog --service=order-service --image=docker.io/keptnexamples/dtdemos/dt-orders-order-services --tag=1

