#!/bin/bash

SSUB=c242e182-fb5f-4bcc-8566-c34d558833ca
CSUB=`az account show --query="id" -o tsv`

if [ $CSUB != $SSUB ]; then
    echo "Cambiando subscripcion"
    az account set --subscription $SSUB || exit -1
fi

SWS=prod
CWS=`terraform workspace show`

if [ $CWS != $SWS ]; then
    terraform workspace select $SWS || exit -2
fi

terraform plan -input=false -var-file=vars-$SWS.tfvars