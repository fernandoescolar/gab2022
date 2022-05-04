#!/bin/bash

echo "set resource group name"
rg="fer-globalazure-2022"

echo "set generic name"
n="fergab22"

echo "login in azure"
az login

echo "create resource group"
az group create \
  --name $rg \
  --location westeurope

echo "create vnet"
az network vnet create \
  --name $n \
  --resource-group $rg \
  --address-prefix 10.0.0.0/8

echo "create aks subnet"
az network vnet subnet create \
  --name aks \
  --resource-group $rg \
  --vnet-name $n \
  --address-prefixes 10.0.0.0/16

echo "crete private endpoints subnet"
az network vnet subnet create \
  --name private_endpoints \
  --resource-group $rg \
  --vnet-name $n \
  --address-prefixes 10.1.0.0/24 \
  --disable-private-endpoint-network-policies

echo "get aks subnet id"
aksSubnet=$(az network vnet subnet show \
  --name aks \
  --resource-group $rg \
  --vnet-name $n \
  --query id \
  --output tsv)

echo "show aks subnet"
echo $aksSubnet

echo "create aks cluster"
az aks create \
  --resource-group $rg \
  --name $n \
  --node-vm-size Standard_B2s \
  --node-count 2 \
  --network-plugin azure \
  --vnet-subnet-id $aksSubnet \
  --service-cidr 10.2.0.0/16 \
  --dns-service-ip 10.2.0.10 \
  --no-ssh-key \
  --yes

echo "create premium acr"
az acr create \
  --resource-group $rg \
  --name $n \
  --sku Premium

echo "disable acr public network access"
az acr update \
  --resource-group $rg \
  --name $n \
  --default-action Deny

echo "get my current ip"
myip=$(curl \
  -s https://api.myip.com/ | jq \
  -r ".ip")

echo "allow access to acr from my ip"
az acr network-rule add \
  -n $n \
  --ip-address $myip/32

echo "create acr dns zone"
az network private-dns zone create \
  --resource-group $rg \
  --name privatelink.azurecr.io

echo "link acr dns zone to vnet"
az network private-dns link vnet create \
  --resource-group $rg \
  --zone-name privatelink.azurecr.io \
  --name ${n}ACRLink \
  --virtual-network $n \
  --registration-enabled false

echo "get acr id"
acrId=$(az acr show \
  --name $n \
  --query id \
  --output tsv)

echo "show acr id"
echo $acrId

echo "create acr private endpoint"
az network private-endpoint create \
  --name ${n}ACRPrivateEndpoint \
  --resource-group $rg \
  --vnet-name $n \
  --subnet private_endpoints \
  --private-connection-resource-id $acrId \
  --group-id registry \
  --connection-name ${n}ACRConnection

echo "get acr NIC"
acrNIC=$(az network private-endpoint show \
  --name ${n}ACRPrivateEndpoint \
  --resource-group $rg \
  --query networkInterfaces[[0]].id \
  --output tsv)

echo "show acr NIC"
echo $acrNIC

echo "get acr private ip"
acrIP1=$(az resource show \
  --ids $acrNIC \
  --api-version 2019-04-01 \
  --query properties.ipConfigurations[[1]].properties.privateIPAddress \
  --output tsv)

echo "show acr private ip"
echo $acrIP1

echo "get acr the other private ip"
acrIP2=$(az resource show \
  --ids $acrNIC \
  --api-version 2019-04-01 \
  --query properties.ipConfigurations[[0]].properties.privateIPAddress \
  --output tsv)

echo "show the other acr private ip"
echo $acrIP2

echo "create acr dns a record"
az network private-dns record-set a create \
  --name $n \
  --zone-name privatelink.azurecr.io \
  --resource-group $rg

echo "create acr dns a record (localized)"
az network private-dns record-set a create \
  --name $1.westeurope.data \
  --zone-name privatelink.azurecr.io \
  --resource-group $rg

echo "add acr dns a record"
az network private-dns record-set a add-record \
  --record-set-name $n \
  --zone-name privatelink.azurecr.io \
  --resource-group $rg \
  --ipv4-address $acrIP1

echo "add acr dns a record (localized)"
az network private-dns record-set a add-record \
  --record-set-name $n.westeurope.data \
  --zone-name privatelink.azurecr.io \
  --resource-group $rg \
  --ipv4-address $acrIP2

echo "attach acr to aks"
az aks update \
  --resource-group $rg \
  --name $n \
  --attach-acr $n

echo "create vault"
az keyvault create \
  --resource-group $rg \
  --name $n \
  --location westeurope

echo "add vault firewall default behavior: deny"
az keyvault update \
  --resource-group $rg \
  --name $n \
  --default-action deny

echo "allow traffic from my ip"
az keyvault network-rule add \
  --name $n \
  --ip-address $myip/32

echo "create secret"
az keyvault secret set \
  --vault-name $n \
  -n TestSecret \
  --value "ola k ase"

echo "create vault dns zone"
az network private-dns zone create \
  --resource-group $rg \
  --name privatelink.vaultcore.azure.net

echo "link vault dns zone to vnet"
az network private-dns link vnet create \
  --resource-group $rg \
  --zone-name privatelink.vaultcore.azure.net \
  --name ${n}VaultLink \
  --virtual-network $n \
  --registration-enabled false

echo "get vault id"
vaultId=$(az keyvault show \
  --name $n \
  --query id \
  --output tsv)

echo "show vault id"
echo $vaultId

echo "create vault private endpoint"
az network private-endpoint create \
  --name ${n}VaultPrivateEndpoint \
  --resource-group $rg \
  --vnet-name $n \
  --subnet private_endpoints \
  --private-connection-resource-id $vaultId \
  --group-id vault \
  --connection-name ${n}VaultConnection

echo "get vault NIC"
vaultNIC=$(az network private-endpoint show \
  --name ${n}VaultPrivateEndpoint \
  --resource-group $rg \
  --query networkInterfaces[[0]].id \
  --output tsv)

echo "show vault NIC"
echo $vaultNIC

echo "get vault private ip"
vaultIP=$(az resource show \
  --ids $vaultNIC \
  --api-version 2019-04-01 \
  --query properties.ipConfigurations[[0]].properties.privateIPAddress \
  --output tsv)

echo "show vault private ip"
echo $vaultIP

echo "create vault dns a record"
az network private-dns record-set a create \
  --name $n \
  --zone-name privatelink.vaultcore.azure.net \
  --resource-group $rg

echo "add vault dns a record"
az network private-dns record-set a add-record \
  --record-set-name $n \
  --zone-name privatelink.vaultcore.azure.net \
  --resource-group $rg \
  --ipv4-address $vaultIP

echo "enabled aks addon for keyvault integration"
az aks enable-addons \
  --addons azure-keyvault-secrets-provider \
  -g $rg \
  -n $n

echo "search identity object id"
aks_object_id=$(az aks show \
  -g $rg \
  -n $n \
  --query identityProfile.kubeletidentity.objectId \
  -o tsv)

echo "create read policy for identity"
az keyvault set-policy \
  --name $n \
  --object-id $aks_object_id \
  --secret-permissions get list \
  --key-permissions get list \
  --certificate-permissions get list

echo "connect to aks"
az aks get-credentials \
  --resource-group $rg \
  --name $n

echo "add nginx helm repo"
helm repo add nginx https://kubernetes.github.io/ingress-nginx

echo "update helm repo"
helm repo update

echo "install nginx ingress controller"
helm upgrade ingress-nginx nginx/ingress-nginx \
  --namespace nginx \
  --create-namespace \
  --install

echo "add prometheus community helm repo"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

echo "update helm repos"
helm repo update

echo "install prometheus stack"
helm upgrade prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --install

echo "check running pods"
k get pods \
  -A

echo "ACR docker login"
docker login $n.azurecr.io
