#!/bin/bash
# use to change the jmeter service.

sudo bashas "kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/${ALT_JMETER_SERVICE_BRANCH}/jmeter-service/deploy/service.yaml -n keptn --record"

sleep 10

sudo kubectl get pods --all-namespaces | grep jmeter