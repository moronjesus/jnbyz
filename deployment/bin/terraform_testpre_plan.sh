#!/bin/bash

SSUB=dc5ccce8-12e9-452d-86d2-19c5d2efc1dc
CSUB=`az account show --query="id" -o tsv`

if [ $CSUB != $SSUB ]; then
    echo "Cambiando subscripcion"
    az account set --subscription $SSUB || exit -1
fi

SWS=testpre
CWS=`terraform workspace show`

if [ $CWS != $SWS ]; then
    terraform workspace select $SWS || exit -2
fi

terraform plan -input=false -var-file=vars-$SWS.tfvars
