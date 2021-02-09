#!/bin/bash
# use to change the jmeter service.

ALT_JMETER_SERVICE_BRANCH="release-0.7.3-patch1"

# use for host aliases
sudo kubectl apply -f https://raw.githubusercontent.com/dthotday-performance/keptn/${ALT_JMETER_SERVICE_BRANCH}/configuration-service/deploy/service.yaml -n keptn --record

sleep 10

sudo kubectl get pods --all-namespaces | grep jmeter
