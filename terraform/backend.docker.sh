#!/bin/bash
set -e 

AZ_DOCKER_CMD="docker run -it --rm  mcr.microsoft.com/azure-cli:latest /bin/bash -c"

# AZ_DOCKER_CMD='docker run -it --rm -v azure-cli:/root/.azure mcr.microsoft.com/azure-cli:latest'

RESOURCE_LOCATION="germanywestcentral"
TF_STATE_RESOURCE_GROUP_NAME=$TF_VAR_STATE_RESOURCE_GROUP_NAME
TF_STATE_STORAGE_ACCOUNT_NAME=$TF_VAR_STATE_STORAGE_ACCOUNT_NAME"stmydemoshared001"
TF_STATE_CONTAINER_NAME=$TF_VAR_STATE_CONTAINER_NAME

# # Persistent volume for login
# docker volume create azure-cli

# Login
${AZ_DOCKER_CMD} "az login && \
    az group create --name $TF_STATE_RESOURCE_GROUP_NAME --location $RESOURCE_LOCATION && \
    az storage account create --resource-group $TF_STATE_RESOURCE_GROUP_NAME --name $TF_STATE_STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob && \
    ACCOUNT_KEY=\$(az storage account keys list --resource-group $TF_STATE_RESOURCE_GROUP_NAME --account-name $TF_STATE_STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv) && \
    echo access_key: \$ACCOUNT_KEY && \
    az storage container create --name $TF_STATE_CONTAINER_NAME --account-name $TF_STATE_STORAGE_ACCOUNT_NAME --account-key \$ACCOUNT_KEY && \
    echo TF_STATE_STORAGE_ACCOUNT_NAME: $TF_STATE_STORAGE_ACCOUNT_NAME && \
    echo TF_STATE_CONTAINER_NAME: $TF_STATE_CONTAINER_NAME"
