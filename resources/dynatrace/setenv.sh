#!/bin/bash
source ../dynatrace/utils.sh

readCredsFromFile
printVariables

export DT_TENANT=$DT_TENANT
export DT_API_TOKEN=$DT_API_TOKEN
export DT_PAAS_TOKEN=$DT_PAAS_TOKEN

