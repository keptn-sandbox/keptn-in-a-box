#!/bin/bash
# use to change the jmeter service.

sudo kubectl -n keptn set image deployment/jmeter-service jmeter-service=keptncontrib/jmeter-extended-service:0.2.0 --record

sleep 10

sudo kubectl get pods --all-namespaces | grep jmeter