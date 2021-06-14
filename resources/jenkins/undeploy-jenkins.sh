#!/bin/bash -x

# clean up
helm del jenkins
kubectl delete ns jenkins