#!/bin/bash

set -e

TERRAFORM_COMMAND='apply'
OPTIONS=("plan" "apply" "destroy")
ERROR_MESSAGE="\n -> no argument \n -> 'plan' \n -> 'apply' \n -> 'destroy'\n"

if [ $# -gt 1 ]
then
    printf "This script will only accept one of the following:$ERROR_MESSAGE"
    exit 0
fi

if [[ ! " ${OPTIONS[*]} " =~ " $1 " && ! $# -eq 0 ]]
then
    printf "The following argument is not recognised by this script: \n -> '$1'\nPlease use one of the following:$ERROR_MESSAGE"
fi

if [ $# -eq 1 ]
then
    TERRAFORM_COMMAND=$1
fi

terraform $TERRAFORM_COMMAND -var-file='vars/pers.tfvars'