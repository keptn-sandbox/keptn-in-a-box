#!/bin/bash -x

# clean up
helm del gitea --namespace git
kubectl delete ns git