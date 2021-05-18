#!/usr/bin/env bash
set -e

RESOURCE_GROUP="grocyResourceGroup"

az group create --name "$RESOURCE_GROUP" --location westeurope

az vm create \
    --resource-group "$RESOURCE_GROUP" \
    --name grocyVM \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys

az vm open-port --port 80 --resource-group "$RESOURCE_GROUP" --name grocyVM

# Recreate the grocyVM.yml inventory file for new VM, and populate with the new VM IP
echo "[grocyVM]" > grocyVM.yml
az network public-ip list -g grocyResourceGroup --query "[].ipAddress" -o tsv >> grocyVM.yml