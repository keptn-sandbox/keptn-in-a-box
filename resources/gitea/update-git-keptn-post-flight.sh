#!/bin/bash
# Function file for adding created keptn repos to a self-hosted git repository

if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    echo "Domain has been passed: $DOMAIN"
else
    echo "No Domain has been passed, getting it from the Home-Ingress"
    DOMAIN=$(kubectl get ing -n default homepage-ingress -o=jsonpath='{.spec.tls[0].hosts[0]}')
    echo "Domain: $DOMAIN"
fi

source ./gitea-functions.sh $DOMAIN

# get Tokens for the User
#getApiTokens

# create an Api Token
#createApiToken

# read the Token and keep the hash in memory
readApiTokenFromFile

# create a repo for each keptn project and migrate it.
updateKeptnRepos
#createKeptnRepos
