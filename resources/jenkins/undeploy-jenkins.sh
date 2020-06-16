#!/bin/bash -x

# clean up
helm del --purge jenkins
kubectl delete ns jenkins