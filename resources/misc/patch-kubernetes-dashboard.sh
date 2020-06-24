#!/bin/bash 
kubectl -n kube-system patch deployments kubernetes-dashboard --patch "$(cat skip-login-in-k8-dashboard-patch.yaml)"
