#!/bin/bash
# use to change the jmeter service.

ALT_JMETER_SERVICE_BRANCH="release-0.7.3-patch1"

# 
#sudo kubectl apply -f https://raw.githubusercontent.com/keptn/keptn/${ALT_JMETER_SERVICE_BRANCH}/jmeter-service/deploy/service.yaml -n keptn --record
# use for host aliases 
sudo kubectl apply -f https://raw.githubusercontent.com/dthotday-performance/keptn/${ALT_JMETER_SERVICE_BRANCH}/jmeter-service/deploy/service.yaml -n keptn --record

sleep 10

sudo kubectl get pods --all-namespaces | grep jmeter
