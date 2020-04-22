#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'
FILE="creds_dt.json"

readCredsFromFile() {
    if [ -f "$FILE" ]; then
        CREDS=$(cat $FILE)
        DT_TENANT=$(echo $CREDS | jq -r '.dynatraceTenant')
        DT_API_TOKEN=$(echo $CREDS | jq -r '.dynatraceApiToken')
        DT_PAAS_TOKEN=$(echo $CREDS | jq -r '.dynatracePaaSToken')
    fi
}
printVariables(){
    echo "Dynatrace Tenant (DT_TENANT): $DT_TENANT"
    echo "Dynatrace API Token (DT_API_TOKEN): $DT_API_TOKEN"
    echo "Dynatrace PaaS Token (DT_PAAS_TOKEN): $DT_PAAS_TOKEN"
    export DT_TENANT=$DT_TENANT
    export DT_API_TOKEN=$DT_API_TOKEN
    export DT_PAAS_TOKEN=$DT_PAAS_TOKEN
}
writeCreadsToFile(){
    echo ""
    echo -e "${YLW}Please confirm the values are correct: ${NC}"
    printVariables
    read -p "Is this all correct? (y/n) : " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        NEWCREDS=$(echo $CREDS | \
        jq --arg DT_TENANT "$DT_TENANT" '.dynatraceTenant = $DT_TENANT' | \
        jq --arg DT_API_TOKEN "$DT_API_TOKEN" '.dynatraceApiToken = $DT_API_TOKEN' | \
        jq --arg DT_PAAS_TOKEN "$DT_PAAS_TOKEN" '.dynatracePaaSToken = $DT_PAAS_TOKEN')
        CREDS=$NEWCREDS
        echo $CREDS > $FILE
        echo ""
        echo "The new credentials can be found here:" $FILE
        echo ""
    fi
}

readCredsFromTerminal(){
    echo -e "${YLW}Please enter the credentials as requested below: ${NC}"
    read -p "Dynatrace Tenant {your-domain}/e/{your-environment-id} for managed or {your-environment-id}.live.dynatrace.com for SaaS (default=$DT_TENANT): " DT_TENANT_I
    read -p "Dynatrace API Token (default=$DT_API_TOKEN): " DT_API_TOKEN_I
    read -p "Dynatrace PaaS Token (default=$DT_PAAS_TOKEN): " DT_PAAS_TOKEN_I
    echo ""

    # Only if there is a value the variable will be replaced, otherwise is left as it was 
    if [ -n "${DT_TENANT_I}" ]; then
        DT_TENANT=$DT_TENANT_I
    fi
    if [ -n "${DT_API_TOKEN_I}" ]; then
        DT_API_TOKEN=$DT_API_TOKEN_I
    fi
    if [ -n "${DT_PAAS_TOKEN_I}" ]; then
        DT_PAAS_TOKEN=$DT_PAAS_TOKEN_I
    fi
}

readAndReplaceIfNew(){
    readCredsFromFile
    readCredsFromTerminal
    writeCreadsToFile
}

