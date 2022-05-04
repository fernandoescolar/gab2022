
@prompt [green]fer[/] [purple]says[/] [yellow]~/gab2022[/]\n$\s
@loading 200
[yellow]Initializing console interrupts[/]
@loading 1000
  [grey]LOG:[/] adding key handler[grey]...[/]
@loading 3000
  [grey]LOG:[/] adding stdout manager[grey]...[/]
@loading 2000
  [grey]LOG:[/] adding stdin interceptor[grey]...[/]
@loading 1000
[bold blue]Configuring terminal[/]
@loading 1000
  [grey]LOG:[/] adding az commands checker[grey]...[/]
@loading 2000
  [grey]LOG:[/] adding guid obfuscator[grey]...[/]
@loading 2000
  [grey]LOG:[/] setup syntax highlighter[grey]...[/]
@loading 3000
[bold blue]Installing tweaks[/]
@loading 1000
  [grey]LOG:[/] setup fast dns[grey]...[/]
@loading 1000
  [grey]LOG:[/] setup az fast cli plugin[grey]...[/]
@loading 1000
  [grey]LOG:[/] checking kube aliases[grey]...[/]
@loading 2000
[bold green]Restarting terminal...[/]
@loading 1000
@clear
# set resource group name
$ rg="fer-globalazure-2022"

# set generic name
$ n="fergab22"

# create resource group
$ az group create --name $rg --location westeurope
@running 2000
{
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022",
  "location": "westeurope",
  "managedBy": null,
  "name": "fer-globalazure-2022",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}

# create vnet
$ az network vnet create --name $n --resource-group $rg --address-prefix 10.0.0.0/8
@sleep 2000
{
  "newVNet": {
    "addressSpace": {
      "addressPrefixes": [[
        "10.0.0.0/8"
      ]]
    },
    "bgpCommunities": null,
    "ddosProtectionPlan": null,
    "dhcpOptions": {
      "dnsServers": [[]]
    },
    "enableDdosProtection": false,
    "enableVmProtection": null,
    "encryption": null,
    "etag": "W/\"********-****-****-****-*********40c\"",
    "extendedLocation": null,
    "flowTimeoutInMinutes": null,
    "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/virtualNetworks/fergab22",
    "ipAllocations": null,
    "location": "westeurope",
    "name": "fergab22",
    "provisioningState": "Succeeded",
    "resourceGroup": "fer-globalazure-2022",
    "resourceGuid": "********-****-****-****-*********2fc",
    "subnets": [[]],
    "tags": {},
    "type": "Microsoft.Network/virtualNetworks",
    "virtualNetworkPeerings": [[]]
  }
}

# create aks subnet
$ az network vnet subnet create --name aks --resource-group $rg --vnet-name $n --address-prefixes 10.0.0.0/16
@sleep 1500
{
  "addressPrefix": "10.0.0.0/16",
  "addressPrefixes": null,
  "applicationGatewayIpConfigurations": null,
  "delegations": [[]],
  "etag": "W/\"********-****-****-****-*********f5a\"",
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/virtualNetworks/fergab22/subnets/aks",
  "ipAllocations": null,
  "ipConfigurationProfiles": null,
  "ipConfigurations": null,
  "name": "aks",
  "natGateway": null,
  "networkSecurityGroup": null,
  "privateEndpointNetworkPolicies": "Enabled",
  "privateEndpoints": null,
  "privateLinkServiceNetworkPolicies": "Enabled",
  "provisioningState": "Succeeded",
  "purpose": null,
  "resourceGroup": "fer-globalazure-2022",
  "resourceNavigationLinks": null,
  "routeTable": null,
  "serviceAssociationLinks": null,
  "serviceEndpointPolicies": null,
  "serviceEndpoints": null,
  "type": "Microsoft.Network/virtualNetworks/subnets"
}

# crete private endpoints subnet
$ az network vnet subnet create --name private_endpoints --resource-group $rg --vnet-name $n --address-prefixes 10.1.0.0/24 --disable-private-endpoint-network-policies
@sleep 3000
{
  "addressPrefix": "10.1.0.0/24",
  "addressPrefixes": null,
  "applicationGatewayIpConfigurations": null,
  "delegations": [[]],
  "etag": "W/\"********-****-****-****-*********684\"",
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/virtualNetworks/fergab22/subnets/private_endpoints",
  "ipAllocations": null,
  "ipConfigurationProfiles": null,
  "ipConfigurations": null,
  "name": "private_endpoints",
  "natGateway": null,
  "networkSecurityGroup": null,
  "privateEndpointNetworkPolicies": "Disabled",
  "privateEndpoints": null,
  "privateLinkServiceNetworkPolicies": "Enabled",
  "provisioningState": "Succeeded",
  "purpose": null,
  "resourceGroup": "fer-globalazure-2022",
  "resourceNavigationLinks": null,
  "routeTable": null,
  "serviceAssociationLinks": null,
  "serviceEndpointPolicies": null,
  "serviceEndpoints": null,
  "type": "Microsoft.Network/virtualNetworks/subnets"
}

# get aks subnet id
$ aksSubnet=$(az network vnet subnet show --name aks --resource-group $rg --vnet-name $n --query id --output tsv)
@sleep 1000

# show aks subnet
$ echo $aksSubnet
/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/virtualNetworks/fergab22/subnets/aks

# create aks cluster
$ az aks create --resource-group $rg --name $n --node-vm-size Standard_B2s --node-count 2 --network-plugin azure --vnet-subnet-id $aksSubnet --service-cidr 10.2.0.0/16 --dns-service-ip 10.2.0.10 --no-ssh-key --yes
@running 30000
{
  "aadProfile": null,
  "addonProfiles": null,
  "agentPoolProfiles": [[
    {
      "availabilityZones": null,
      "count": 2,
      "creationData": null,
      "enableAutoScaling": false,
      "enableEncryptionAtHost": false,
      "enableFips": false,
      "enableNodePublicIp": false,
      "enableUltraSsd": false,
      "gpuInstanceProfile": null,
      "kubeletConfig": null,
      "kubeletDiskType": "OS",
      "linuxOsConfig": null,
      "maxCount": null,
      "maxPods": 30,
      "minCount": null,
      "mode": "System",
      "name": "nodepool1",
      "nodeImageVersion": "AKSUbuntu-1804gen2containerd-2022.04.05",
      "nodeLabels": null,
      "nodePublicIpPrefixId": null,
      "nodeTaints": null,
      "orchestratorVersion": "1.22.6",
      "osDiskSizeGb": 128,
      "osDiskType": "Managed",
      "osSku": "Ubuntu",
      "osType": "Linux",
      "podSubnetId": null,
      "powerState": {
        "code": "Running"
      },
      "provisioningState": "Succeeded",
      "proximityPlacementGroupId": null,
      "scaleDownMode": null,
      "scaleSetEvictionPolicy": null,
      "scaleSetPriority": null,
      "spotMaxPrice": null,
      "tags": null,
      "type": "VirtualMachineScaleSets",
      "upgradeSettings": null,
      "vmSize": "Standard_B2s",
      "vnetSubnetId": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/virtualNetworks/fergab22/subnets/aks",
      "workloadRuntime": null
    }
  ]],
  "apiServerAccessProfile": null,
  "autoScalerProfile": null,
  "autoUpgradeProfile": null,
  "azurePortalFqdn": "fergab22-fer-globalazure--2a50e8-1ecc2c9a.portal.hcp.westeurope.azmk8s.io",
  "disableLocalAccounts": false,
  "diskEncryptionSetId": null,
  "dnsPrefix": "fergab22-fer-globalazure--2a50e8",
  "enablePodSecurityPolicy": null,
  "enableRbac": true,
  "extendedLocation": null,
  "fqdn": "fergab22-fer-globalazure--2a50e8-1ecc2c9a.hcp.westeurope.azmk8s.io",
  "fqdnSubdomain": null,
  "httpProxyConfig": null,
  "id": "/subscriptions/********-****-****-****-*********16e/resourcegroups/fer-globalazure-2022/providers/Microsoft.ContainerService/managedClusters/fergab22",
  "identity": {
    "principalId": "********-****-****-****-*********729",
    "tenantId": "********-****-****-****-*********35d",
    "type": "SystemAssigned",
    "userAssignedIdentities": null
  },
  "identityProfile": {
    "kubeletidentity": {
      "clientId": "********-****-****-****-*********d00",
      "objectId": "********-****-****-****-*********ca4",
      "resourceId": "/subscriptions/********-****-****-****-*********16e/resourcegroups/MC_fer-globalazure-2022_fergab22_westeurope/providers/Microsoft.ManagedIdentity/userAssignedIdentities/fergab22-agentpool"
    }
  },
  "kubernetesVersion": "1.22.6",
  "linuxProfile": null,
  "location": "westeurope",
  "maxAgentPools": 100,
  "name": "fergab22",
  "networkProfile": {
    "dnsServiceIp": "10.2.0.10",
    "dockerBridgeCidr": "172.17.0.1/16",
    "ipFamilies": [[
      "IPv4"
    ]],
    "loadBalancerProfile": {
      "allocatedOutboundPorts": null,
      "effectiveOutboundIPs": [[
        {
          "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/MC_fer-globalazure-2022_fergab22_westeurope/providers/Microsoft.Network/publicIPAddresses/********-****-****-****-*********f95",
          "resourceGroup": "MC_fer-globalazure-2022_fergab22_westeurope"
        }
      ]],
      "enableMultipleStandardLoadBalancers": null,
      "idleTimeoutInMinutes": null,
      "managedOutboundIPs": {
        "count": 1,
        "countIpv6": null
      },
      "outboundIPs": null,
      "outboundIpPrefixes": null
    },
    "loadBalancerSku": "Standard",
    "natGatewayProfile": null,
    "networkMode": null,
    "networkPlugin": "azure",
    "networkPolicy": null,
    "outboundType": "loadBalancer",
    "podCidr": null,
    "podCidrs": null,
    "serviceCidr": "10.2.0.0/16",
    "serviceCidrs": [[
      "10.2.0.0/16"
    ]]
  },
  "nodeResourceGroup": "MC_fer-globalazure-2022_fergab22_westeurope",
  "podIdentityProfile": null,
  "powerState": {
    "code": "Running"
  },
  "privateFqdn": null,
  "privateLinkResources": null,
  "provisioningState": "Succeeded",
  "publicNetworkAccess": null,
  "resourceGroup": "fer-globalazure-2022",
  "securityProfile": {
    "azureDefender": null
  },
  "servicePrincipalProfile": {
    "clientId": "msi",
    "secret": null
  },
  "sku": {
    "name": "Basic",
    "tier": "Free"
  },
  "systemData": null,
  "tags": null,
  "type": "Microsoft.ContainerService/ManagedClusters",
  "windowsProfile": {
    "adminPassword": null,
    "adminUsername": "azureuser",
    "enableCsiProxy": true,
    "gmsaProfile": null,
    "licenseType": null
  }
}

# create premium acr
$ az acr create --resource-group $rg --name $n --sku Premium
@running 10000
{
  "adminUserEnabled": false,
  "anonymousPullEnabled": false,
  "creationDate": "2022-05-07T10:00:10.859419+00:00",
  "dataEndpointEnabled": false,
  "dataEndpointHostNames": [[]],
  "encryption": {
    "keyVaultProperties": null,
    "status": "disabled"
  },
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.ContainerRegistry/registries/fergab22",
  "identity": null,
  "location": "westeurope",
  "loginServer": "fergab22.azurecr.io",
  "name": "fergab22",
  "networkRuleBypassOptions": "AzureServices",
  "networkRuleSet": {
    "defaultAction": "Allow",
    "ipRules": [[]],
    "virtualNetworkRules": [[]]
  },
  "policies": {
    "exportPolicy": {
      "status": "enabled"
    },
    "quarantinePolicy": {
      "status": "disabled"
    },
    "retentionPolicy": {
      "days": 7,
      "lastUpdatedTime": "2022-05-07T10:00:14.419540+00:00",
      "status": "disabled"
    },
    "trustPolicy": {
      "status": "disabled",
      "type": "Notary"
    }
  },
  "privateEndpointConnections": [[]],
  "provisioningState": "Succeeded",
  "publicNetworkAccess": "Enabled",
  "resourceGroup": "fer-globalazure-2022",
  "sku": {
    "name": "Premium",
    "tier": "Premium"
  },
  "status": null,
  "systemData": {
    "createdAt": "2022-05-07T10:00:10.859419+00:00",
    "createdBy": "********-****-****-****-*********469",
    "createdByType": "Application",
    "lastModifiedAt": "2022-05-07T10:00:10.859419+00:00",
    "lastModifiedBy": "********-****-****-****-*********469",
    "lastModifiedByType": "Application"
  },
  "tags": {},
  "type": "Microsoft.ContainerRegistry/registries",
  "zoneRedundancy": "Disabled"
}

# disable acr public network access
$ az acr update --resource-group $rg --name $n --default-action Deny
@running 5000
{
  "adminUserEnabled": false,
  "anonymousPullEnabled": false,
  "creationDate": "2022-05-07T10:00:10.859419+00:00",
  "dataEndpointEnabled": false,
  "dataEndpointHostNames": [[]],
  "encryption": {
    "keyVaultProperties": null,
    "status": "disabled"
  },
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.ContainerRegistry/registries/fergab22",
  "identity": null,
  "location": "westeurope",
  "loginServer": "fergab22.azurecr.io",
  "name": "fergab22",
  "networkRuleBypassOptions": "AzureServices",
  "networkRuleSet": {
    "defaultAction": "Allow",
    "ipRules": [[]],
    "virtualNetworkRules": [[]]
  },
  "policies": {
    "exportPolicy": {
      "status": "enabled"
    },
    "quarantinePolicy": {
      "status": "disabled"
    },
    "retentionPolicy": {
      "days": 7,
      "lastUpdatedTime": "2022-05-07T10:00:14.419540+00:00",
      "status": "disabled"
    },
    "trustPolicy": {
      "status": "disabled",
      "type": "Notary"
    }
  },
  "privateEndpointConnections": [[]],
  "provisioningState": "Succeeded",
  "publicNetworkAccess": "Disabled",
  "resourceGroup": "fer-globalazure-2022",
  "sku": {
    "name": "Premium",
    "tier": "Premium"
  },
  "status": null,
  "systemData": {
    "createdAt": "2022-05-07T10:00:10.859419+00:00",
    "createdBy": "********-****-****-****-*********469",
    "createdByType": "Application",
    "lastModifiedAt": "2022-05-07T10:01:43.156531+00:00",
    "lastModifiedBy": "********-****-****-****-*********469",
    "lastModifiedByType": "Application"
  },
  "tags": {},
  "type": "Microsoft.ContainerRegistry/registries",
  "zoneRedundancy": "Disabled"
}

# get my current ip
$ myip=$(curl -s https://api.myip.com/ | jq -r ".ip")

# allow access to acr from my ip
$ az acr network-rule add -n $n --ip-address $myip/32
@sleep 500
{
  "adminUserEnabled": false,
  "anonymousPullEnabled": false,
  "creationDate": "2022-05-03T07:33:41.932297+00:00",
  "dataEndpointEnabled": false,
  "dataEndpointHostNames": [[]],
  "encryption": {
    "keyVaultProperties": null,
    "status": "disabled"
  },
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.ContainerRegistry/registries/fergab22",
  "identity": null,
  "location": "westeurope",
  "loginServer": "fergab22.azurecr.io",
  "name": "fergab22",
  "networkRuleBypassOptions": "AzureServices",
  "networkRuleSet": {
    "defaultAction": "Allow",
    "ipRules": [[
      {
        "action": "Allow",
        "ipAddressOrRange": "***.***.***.***"
      }
    ]],
    "virtualNetworkRules": [[]]
  },
  "policies": {
    "exportPolicy": {
      "status": "enabled"
    },
    "quarantinePolicy": {
      "status": "disabled"
    },
    "retentionPolicy": {
      "days": 7,
      "lastUpdatedTime": "2022-05-07T10:00:44.945050+00:00",
      "status": "disabled"
    },
    "trustPolicy": {
      "status": "disabled",
      "type": "Notary"
    }
  },
  "privateEndpointConnections": [[]],
  "provisioningState": "Succeeded",
  "publicNetworkAccess": "Disabled",
  "resourceGroup": "fer-globalazure-2022",
  "sku": {
    "name": "Premium",
    "tier": "Premium"
  },
  "status": null,
  "systemData": {
    "createdAt": "2022-05-07T10:00:41.932297+00:00",
    "createdBy": "********-****-****-****-*********469",
    "createdByType": "Application",
    "lastModifiedAt": "2022-05-07T10:00:31.460046+00:00",
    "lastModifiedBy": "********-****-****-****-*********469",
    "lastModifiedByType": "Application"
  },
  "tags": {},
  "type": "Microsoft.ContainerRegistry/registries",
  "zoneRedundancy": "Disabled"
}

# create acr dns zone
$ az network private-dns zone create --resource-group $rg --name privatelink.azurecr.io
@running 4000
{
  "etag": "********-****-****-****-*********b44",
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io",
  "location": "global",
  "maxNumberOfRecordSets": 25000,
  "maxNumberOfVirtualNetworkLinks": 1000,
  "maxNumberOfVirtualNetworkLinksWithRegistration": 100,
  "name": "privatelink.azurecr.io",
  "numberOfRecordSets": 1,
  "numberOfVirtualNetworkLinks": 0,
  "numberOfVirtualNetworkLinksWithRegistration": 0,
  "provisioningState": "Succeeded",
  "resourceGroup": "fer-globalazure-2022",
  "tags": null,
  "type": "Microsoft.Network/privateDnsZones"
}

# link acr dns zone to vnet
$ az network private-dns link vnet create --resource-group $rg --zone-name privatelink.azurecr.io --name ${n}ACRLink --virtual-network $n --registration-enabled false
@running 10000
{
  "etag": "\"********-****-****-****-*********000\"",
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io/virtualNetworkLinks/fergab22acrlink",
  "location": "global",
  "name": "fergab22acrlink",
  "provisioningState": "Succeeded",
  "registrationEnabled": false,
  "resourceGroup": "fer-globalazure-2022",
  "tags": null,
  "type": "Microsoft.Network/privateDnsZones/virtualNetworkLinks",
  "virtualNetwork": {
    "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/virtualNetworks/fergab22",
    "resourceGroup": "fer-globalazure-2022"
  },
  "virtualNetworkLinkState": "Completed"
}

# get acr id
$ acrId=$(az acr show --name $n --query id --output tsv)
@sleep 500

# show acr id
$ echo $acrId
/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.ContainerRegistry/registries/fergab22

# create acr private endpoint
$ az network private-endpoint create --name ${n}ACRPrivateEndpoint --resource-group $rg --vnet-name $n --subnet private_endpoints --private-connection-resource-id $acrId --group-id registry --connection-name ${n}ACRConnection
@running 8000
{
  "applicationSecurityGroups": null,
  "customDnsConfigs": [[
    {
      "fqdn": "fergab22.westeurope.data.azurecr.io",
      "ipAddresses": [[
        "10.1.0.4"
      ]]
    },
    {
      "fqdn": "fergab22.azurecr.io",
      "ipAddresses": [[
        "10.1.0.5"
      ]]
    }
  ]],
  "customNetworkInterfaceName": "",
  "etag": "W/\"********-****-****-****-*********43a\"",
  "extendedLocation": null,
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateEndpoints/fergab22ACRPrivateEndpoint",
  "ipConfigurations": [[]],
  "location": "westeurope",
  "manualPrivateLinkServiceConnections": [[]],
  "name": "fergab22ACRPrivateEndpoint",
  "networkInterfaces": [[
    {
      "dnsSettings": null,
      "dscpConfiguration": null,
      "enableAcceleratedNetworking": null,
      "enableIpForwarding": null,
      "etag": null,
      "extendedLocation": null,
      "hostedWorkloads": null,
      "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/networkInterfaces/fergab22ACRPrivateEndpoint.nic.********-****-****-****-*********0b5",
      "ipConfigurations": null,
      "location": null,
      "macAddress": null,
      "migrationPhase": null,
      "name": null,
      "networkSecurityGroup": null,
      "nicType": null,
      "primary": null,
      "privateEndpoint": null,
      "privateLinkService": null,
      "provisioningState": null,
      "resourceGroup": "fer-globalazure-2022",
      "resourceGuid": null,
      "tags": null,
      "tapConfigurations": null,
      "type": null,
      "virtualMachine": null,
      "vnetEncryptionSupported": null,
      "workloadType": null
    }
  ]],
  "privateLinkServiceConnections": [[
    {
      "etag": "W/\"********-****-****-****-*********43a\"",
      "groupIds": [[
        "registry"
      ]],
      "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateEndpoints/fergab22ACRPrivateEndpoint/privateLinkServiceConnections/fergab22ACRConnection",
      "name": "fergab22ACRConnection",
      "privateLinkServiceConnectionState": {
        "actionsRequired": "None",
        "description": "Auto-Approved",
        "status": "Approved"
      },
      "privateLinkServiceId": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.ContainerRegistry/registries/fergab22",
      "provisioningState": "Succeeded",
      "requestMessage": null,
      "resourceGroup": "fer-globalazure-2022",
      "type": "Microsoft.Network/privateEndpoints/privateLinkServiceConnections"
    }
  ]],
  "provisioningState": "Succeeded",
  "resourceGroup": "fer-globalazure-2022",
  "subnet": {
    "addressPrefix": null,
    "addressPrefixes": null,
    "applicationGatewayIpConfigurations": null,
    "delegations": null,
    "etag": null,
    "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/virtualNetworks/fergab22/subnets/private_endpoints",
    "ipAllocations": null,
    "ipConfigurationProfiles": null,
    "ipConfigurations": null,
    "name": null,
    "natGateway": null,
    "networkSecurityGroup": null,
    "privateEndpointNetworkPolicies": null,
    "privateEndpoints": null,
    "privateLinkServiceNetworkPolicies": null,
    "provisioningState": null,
    "purpose": null,
    "resourceGroup": "fer-globalazure-2022",
    "resourceNavigationLinks": null,
    "routeTable": null,
    "serviceAssociationLinks": null,
    "serviceEndpointPolicies": null,
    "serviceEndpoints": null,
    "type": null
  },
  "tags": null,
  "type": "Microsoft.Network/privateEndpoints"
}

# get acr NIC
$ acrNIC=$(az network private-endpoint show --name ${n}ACRPrivateEndpoint --resource-group $rg --query networkInterfaces[[0]].id --output tsv)
@sleep 1500

# show acr NIC
$ echo $acrNIC
/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/networkInterfaces/fergab22ACRPrivateEndpoint.nic.********-****-****-****-*********0b5

# get acr private ip
$ acrIP1=$(az resource show --ids $acrNIC --api-version 2019-04-01 --query properties.ipConfigurations[[1]].properties.privateIPAddress --output tsv)
@sleep 1000

# show acr private ip
$ echo $acrIP1
10.1.0.5

# get acr the other private ip
$ acrIP2=$(az resource show --ids $acrNIC --api-version 2019-04-01 --query properties.ipConfigurations[[0]].properties.privateIPAddress --output tsv)

# show the other acr private ip
$ echo $acrIP2
10.1.0.4

# create acr dns a record
$ az network private-dns record-set a create --name $n --zone-name privatelink.azurecr.io --resource-group $rg
@running 4000
{
  "etag": "********-****-****-****-*********63b",
  "fqdn": "fergab22.privatelink.azurecr.io.",
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io/A/fergab22",
  "isAutoRegistered": false,
  "metadata": null,
  "name": "fergab22",
  "resourceGroup": "fer-globalazure-2022",
  "ttl": 3600,
  "type": "Microsoft.Network/privateDnsZones/A"
}

# create acr dns a record (localized)
$ az network private-dns record-set a create --name $n.westeurope.data --zone-name privatelink.azurecr.io --resource-group $rg
@running 5000
{
  "etag": "********-****-****-****-*********10d",
  "fqdn": "fergab22.westeurope.data.privatelink.azurecr.io.",
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io/A/fergab22.westeurope.data",
  "isAutoRegistered": false,
  "metadata": null,
  "name": "fergab22.westeurope.data",
  "resourceGroup": "fer-globalazure-2022",
  "ttl": 3600,
  "type": "Microsoft.Network/privateDnsZones/A"
}

# add acr dns a record
$ az network private-dns record-set a add-record --record-set-name $n --zone-name privatelink.azurecr.io --resource-group $rg --ipv4-address $acrIP1
@running 10000
{
  "aRecords": [[
    {
      "ipv4Address": "10.1.0.5"
    }
  ]],
  "etag": "********-****-****-****-*********57f",
  "fqdn": "fergab22.privatelink.azurecr.io.",
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io/A/fergab22",
  "isAutoRegistered": false,
  "metadata": null,
  "name": "fergab22",
  "resourceGroup": "fer-globalazure-2022",
  "ttl": 3600,
  "type": "Microsoft.Network/privateDnsZones/A"
}

# add acr dns a record (localized)
$ az network private-dns record-set a add-record --record-set-name $n.westeurope.data --zone-name privatelink.azurecr.io --resource-group $rg --ipv4-address $acrIP2
@running 5000
{
  "aRecords": [[
    {
      "ipv4Address": "10.1.0.5"
    }
  ]],
  "etag": "********-****-****-****-*********067",
  "fqdn": "fergab22.westeurope.data.privatelink.azurecr.io.",
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io/A/fergab22.westeurope.data",
  "isAutoRegistered": false,
  "metadata": null,
  "name": "fergab22.westeurope.data",
  "resourceGroup": "fer-globalazure-2022",
  "ttl": 3600,
  "type": "Microsoft.Network/privateDnsZones/A"
}

# attach acr to aks
$ az aks update --resource-group $rg --name $n --attach-acr $n
@running 5000
AAD role propagation done[[############################################]]  100.0000%
{
  "aadProfile": null,
  "addonProfiles": null,
  "agentPoolProfiles": [[
    {
      "availabilityZones": null,
      "count": 2,
      "creationData": null,
      "enableAutoScaling": false,
      "enableEncryptionAtHost": false,
      "enableFips": false,
      "enableNodePublicIp": false,
      "enableUltraSsd": false,
      "gpuInstanceProfile": null,
      "kubeletConfig": null,
      "kubeletDiskType": "OS",
      "linuxOsConfig": null,
      "maxCount": null,
      "maxPods": 30,
      "minCount": null,
      "mode": "System",
      "name": "nodepool1",
      "nodeImageVersion": "AKSUbuntu-1804gen2containerd-2022.04.05",
      "nodeLabels": null,
      "nodePublicIpPrefixId": null,
      "nodeTaints": null,
      "orchestratorVersion": "1.22.6",
      "osDiskSizeGb": 128,
      "osDiskType": "Managed",
      "osSku": "Ubuntu",
      "osType": "Linux",
      "podSubnetId": null,
      "powerState": {
        "code": "Running"
      },
      "provisioningState": "Succeeded",
      "proximityPlacementGroupId": null,
      "scaleDownMode": null,
      "scaleSetEvictionPolicy": null,
      "scaleSetPriority": null,
      "spotMaxPrice": null,
      "tags": null,
      "type": "VirtualMachineScaleSets",
      "upgradeSettings": null,
      "vmSize": "Standard_B2s",
      "vnetSubnetId": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/virtualNetworks/fergab22/subnets/aks",
      "workloadRuntime": null
    }
  ]],
  "apiServerAccessProfile": null,
  "autoScalerProfile": null,
  "autoUpgradeProfile": null,
  "azurePortalFqdn": "fergab22-fer-globalazure--2a50e8-c874f727.portal.hcp.westeurope.azmk8s.io",
  "disableLocalAccounts": false,
  "diskEncryptionSetId": null,
  "dnsPrefix": "fergab22-fer-globalazure--2a50e8",
  "enablePodSecurityPolicy": null,
  "enableRbac": true,
  "extendedLocation": null,
  "fqdn": "fergab22-fer-globalazure--2a50e8-c874f727.hcp.westeurope.azmk8s.io",
  "fqdnSubdomain": null,
  "httpProxyConfig": null,
  "id": "/subscriptions/********-****-****-****-*********16e/resourcegroups/fer-globalazure-2022/providers/Microsoft.ContainerService/managedClusters/fergab22",
  "identity": {
    "principalId": "********-****-****-****-*********b08",
    "tenantId": "********-****-****-****-*********35d",
    "type": "SystemAssigned",
    "userAssignedIdentities": null
  },
  "identityProfile": {
    "kubeletidentity": {
      "clientId": "********-****-****-****-*********010",
      "objectId": "********-****-****-****-*********b47",
      "resourceId": "/subscriptions/********-****-****-****-*********16e/resourcegroups/MC_fer-globalazure-2022_fergab22_westeurope/providers/Microsoft.ManagedIdentity/userAssignedIdentities/fergab22-agentpool"
    }
  },
  "kubernetesVersion": "1.22.6",
  "linuxProfile": null,
  "location": "westeurope",
  "maxAgentPools": 100,
  "name": "fergab22",
  "networkProfile": {
    "dnsServiceIp": "10.2.0.10",
    "dockerBridgeCidr": "172.17.0.1/16",
    "ipFamilies": [[
      "IPv4"
    ]],
    "loadBalancerProfile": {
      "allocatedOutboundPorts": null,
      "effectiveOutboundIPs": [[
        {
          "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/MC_fer-globalazure-2022_fergab22_westeurope/providers/Microsoft.Network/publicIPAddresses/********-****-****-****-*********3a1",
          "resourceGroup": "MC_fer-globalazure-2022_fergab22_westeurope"
        }
      ]],
      "enableMultipleStandardLoadBalancers": null,
      "idleTimeoutInMinutes": null,
      "managedOutboundIPs": {
        "count": 1,
        "countIpv6": null
      },
      "outboundIPs": null,
      "outboundIpPrefixes": null
    },
    "loadBalancerSku": "Standard",
    "natGatewayProfile": null,
    "networkMode": null,
    "networkPlugin": "azure",
    "networkPolicy": null,
    "outboundType": "loadBalancer",
    "podCidr": null,
    "podCidrs": null,
    "serviceCidr": "10.2.0.0/16",
    "serviceCidrs": [[
      "10.2.0.0/16"
    ]]
  },
  "nodeResourceGroup": "MC_fer-globalazure-2022_fergab22_westeurope",
  "podIdentityProfile": null,
  "powerState": {
    "code": "Running"
  },
  "privateFqdn": null,
  "privateLinkResources": null,
  "provisioningState": "Succeeded",
  "publicNetworkAccess": null,
  "resourceGroup": "fer-globalazure-2022",
  "securityProfile": {
    "azureDefender": null
  },
  "servicePrincipalProfile": {
    "clientId": "msi",
    "secret": null
  },
  "sku": {
    "name": "Basic",
    "tier": "Free"
  },
  "systemData": null,
  "tags": null,
  "type": "Microsoft.ContainerService/ManagedClusters",
  "windowsProfile": {
    "adminPassword": null,
    "adminUsername": "azureuser",
    "enableCsiProxy": true,
    "gmsaProfile": null,
    "licenseType": null
  }
}

# create vault
$ az keyvault create --resource-group $rg --name $n --location westeurope
@running 2000
{
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.KeyVault/vaults/fergab22",
  "location": "westeurope",
  "name": "fergab22",
  "properties": {
    "accessPolicies": [[
      {
        "applicationId": null,
        "objectId": "********-****-****-****-*********2da",
        "permissions": {
          "certificates": [[
            "all"
          ]],
          "keys": [[
            "all"
          ]],
          "secrets": [[
            "all"
          ]],
          "storage": [[
            "all"
          ]]
        },
        "tenantId": "********-****-****-****-*********35d"
      }
    ]],
    "createMode": null,
    "enablePurgeProtection": null,
    "enableRbacAuthorization": null,
    "enableSoftDelete": true,
    "enabledForDeployment": false,
    "enabledForDiskEncryption": null,
    "enabledForTemplateDeployment": null,
    "hsmPoolResourceId": null,
    "networkAcls": null,
    "privateEndpointConnections": null,
    "provisioningState": "Succeeded",
    "publicNetworkAccess": "Enabled",
    "sku": {
      "family": "A",
      "name": "standard"
    },
    "softDeleteRetentionInDays": 90,
    "tenantId": "********-****-****-****-*********35d",
    "vaultUri": "https://fergab22.vault.azure.net/"
  },
  "resourceGroup": "fer-globalazure-2022",
  "systemData": {
    "createdAt": "2022-05-07T10:00:26.361000+00:00",
    "createdBy": "********-****-****-****-*********469",
    "createdByType": "Application",
    "lastModifiedAt": "2022-05-07T10:00:26.361000+00:00",
    "lastModifiedBy": "********-****-****-****-*********469",
    "lastModifiedByType": "Application"
  },
  "tags": {},
  "type": "Microsoft.KeyVault/vaults"
}

# add vault firewall default behavior: deny
$ az keyvault update --resource-group $rg --name $n --default-action deny
@sleep 1000
{
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.KeyVault/vaults/fergab22",
  "location": "westeurope",
  "name": "fergab22",
  "properties": {
    "accessPolicies": [[
      {
        "applicationId": null,
        "objectId": "********-****-****-****-*********2da",
        "permissions": {
          "certificates": [[
            "all"
          ]],
          "keys": [[
            "all"
          ]],
          "secrets": [[
            "all"
          ]],
          "storage": [[
            "all"
          ]]
        },
        "tenantId": "********-****-****-****-*********35d"
      }
    ]],
    "createMode": null,
    "enablePurgeProtection": null,
    "enableRbacAuthorization": null,
    "enableSoftDelete": true,
    "enabledForDeployment": false,
    "enabledForDiskEncryption": null,
    "enabledForTemplateDeployment": null,
    "hsmPoolResourceId": null,
    "networkAcls": {
      "bypass": "AzureServices",
      "defaultAction": "Deny",
      "ipRules": [[]],
      "virtualNetworkRules": [[]]
    },
    "privateEndpointConnections": null,
    "provisioningState": "Succeeded",
    "publicNetworkAccess": "Enabled",
    "sku": {
      "family": "A",
      "name": "standard"
    },
    "softDeleteRetentionInDays": 90,
    "tenantId": "********-****-****-****-*********35d",
    "vaultUri": "https://fergab22.vault.azure.net/"
  },
  "resourceGroup": "fer-globalazure-2022",
  "systemData": {
    "createdAt": "2022-05-07T10:00:26.361000+00:00",
    "createdBy": "********-****-****-****-*********469",
    "createdByType": "Application",
    "lastModifiedAt": "2022-05-07T10:00:36.347000+00:00",
    "lastModifiedBy": "********-****-****-****-*********469",
    "lastModifiedByType": "Application"
  },
  "tags": {},
  "type": "Microsoft.KeyVault/vaults"
}

# allow traffic from my ip
$ az keyvault network-rule add --name $n --ip-address $myip/32
@sleep 1000
{
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.KeyVault/vaults/fergab22",
  "location": "westeurope",
  "name": "fergab22",
  "properties": {
    "accessPolicies": [[
      {
        "applicationId": null,
        "objectId": "********-****-****-****-*********2da",
        "permissions": {
          "certificates": [[
            "all"
          ]],
          "keys": [[
            "all"
          ]],
          "secrets": [[
            "all"
          ]],
          "storage": [[
            "all"
          ]]
        },
        "tenantId": "********-****-****-****-*********35d"
      }
    ]],
    "createMode": null,
    "enablePurgeProtection": null,
    "enableRbacAuthorization": null,
    "enableSoftDelete": true,
    "enabledForDeployment": false,
    "enabledForDiskEncryption": null,
    "enabledForTemplateDeployment": null,
    "hsmPoolResourceId": null,
    "networkAcls": {
      "bypass": "AzureServices",
      "defaultAction": "Deny",
      "ipRules": [[
        {
          "value": "***.***.***.***/32"
        }
      ]],
      "virtualNetworkRules": [[]]
    },
    "privateEndpointConnections": null,
    "provisioningState": "Succeeded",
    "publicNetworkAccess": "Enabled",
    "sku": {
      "family": "A",
      "name": "standard"
    },
    "softDeleteRetentionInDays": 90,
    "tenantId": "********-****-****-****-*********35d",
    "vaultUri": "https://fergab22.vault.azure.net/"
  },
  "resourceGroup": "fer-globalazure-2022",
  "systemData": {
    "createdAt": "2022-05-07T10:00:50.225000+00:00",
    "createdBy": "********-****-****-****-*********469",
    "createdByType": "Application",
    "lastModifiedAt": "2022-05-07T10:00:34.221000+00:00",
    "lastModifiedBy": "********-****-****-****-*********469",
    "lastModifiedByType": "Application"
  },
  "tags": {},
  "type": "Microsoft.KeyVault/vaults"
}

# create secret
$ az keyvault secret set --vault-name $n -n TestSecret --value "ola k ase"
{
  "attributes": {
    "created": "2022-05-07T10:00:43+00:00",
    "enabled": true,
    "expires": null,
    "notBefore": null,
    "recoveryLevel": "Recoverable+Purgeable",
    "updated": "2022-05-07T10:00:43+00:00"
  },
  "contentType": null,
  "id": "https://fergab22.vault.azure.net/secrets/TestSecret/*****************************469",
  "kid": null,
  "managed": null,
  "name": "TestSecret",
  "tags": {
    "file-encoding": "utf-8"
  },
  "value": "ola k ase"
}

# create vault dns zone
$ az network private-dns zone create --resource-group $rg --name privatelink.vaultcore.azure.net
@running 1000
{
  "etag": "********-****-****-****-*********3fe",
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net",
  "location": "global",
  "maxNumberOfRecordSets": 25000,
  "maxNumberOfVirtualNetworkLinks": 1000,
  "maxNumberOfVirtualNetworkLinksWithRegistration": 100,
  "name": "privatelink.vaultcore.azure.net",
  "numberOfRecordSets": 1,
  "numberOfVirtualNetworkLinks": 0,
  "numberOfVirtualNetworkLinksWithRegistration": 0,
  "provisioningState": "Succeeded",
  "resourceGroup": "fer-globalazure-2022",
  "tags": null,
  "type": "Microsoft.Network/privateDnsZones"
}

# link vault dns zone to vnet
$ az network private-dns link vnet create --resource-group $rg --zone-name privatelink.vaultcore.azure.net --name ${n}VaultLink --virtual-network $n --registration-enabled false
@running 1000
{
  "etag": "\"********-****-****-****-*********000\"",
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net/virtualNetworkLinks/fergab22vaultlink",
  "location": "global",
  "name": "fergab22vaultlink",
  "provisioningState": "Succeeded",
  "registrationEnabled": false,
  "resourceGroup": "fer-globalazure-2022",
  "tags": null,
  "type": "Microsoft.Network/privateDnsZones/virtualNetworkLinks",
  "virtualNetwork": {
    "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/virtualNetworks/fergab22",
    "resourceGroup": "fer-globalazure-2022"
  },
  "virtualNetworkLinkState": "Completed"
}

# get vault id
$ vaultId=$(az keyvault show --name $n --query id --output tsv)
@sleep 1000

# show vault id
$ echo $vaultId
/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.KeyVault/vaults/fergab22

# create vault private endpoint
$ az network private-endpoint create --name ${n}VaultPrivateEndpoint --resource-group $rg --vnet-name $n --subnet private_endpoints --private-connection-resource-id $vaultId --group-id vault --connection-name ${n}VaultConnection
@running 2000
{
  "applicationSecurityGroups": null,
  "customDnsConfigs": [[
    {
      "fqdn": "fergab22.vault.azure.net",
      "ipAddresses": [[
        "10.1.0.6"
      ]]
    }
  ]],
  "customNetworkInterfaceName": "",
  "etag": "W/\"********-****-****-****-*********174\"",
  "extendedLocation": null,
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateEndpoints/fergab22VaultPrivateEndpoint",
  "ipConfigurations": [[]],
  "location": "westeurope",
  "manualPrivateLinkServiceConnections": [[]],
  "name": "fergab22VaultPrivateEndpoint",
  "networkInterfaces": [[
    {
      "dnsSettings": null,
      "dscpConfiguration": null,
      "enableAcceleratedNetworking": null,
      "enableIpForwarding": null,
      "etag": null,
      "extendedLocation": null,
      "hostedWorkloads": null,
      "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/networkInterfaces/fergab22VaultPrivateEndpoint.nic.********-****-****-****-*********851",
      "ipConfigurations": null,
      "location": null,
      "macAddress": null,
      "migrationPhase": null,
      "name": null,
      "networkSecurityGroup": null,
      "nicType": null,
      "primary": null,
      "privateEndpoint": null,
      "privateLinkService": null,
      "provisioningState": null,
      "resourceGroup": "fer-globalazure-2022",
      "resourceGuid": null,
      "tags": null,
      "tapConfigurations": null,
      "type": null,
      "virtualMachine": null,
      "vnetEncryptionSupported": null,
      "workloadType": null
    }
  ]],
  "privateLinkServiceConnections": [[
    {
      "etag": "W/\"********-****-****-****-*********174\"",
      "groupIds": [[
        "vault"
      ]],
      "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateEndpoints/fergab22VaultPrivateEndpoint/privateLinkServiceConnections/fergab22VaultConnection",
      "name": "fergab22VaultConnection",
      "privateLinkServiceConnectionState": {
        "actionsRequired": "None",
        "description": "",
        "status": "Approved"
      },
      "privateLinkServiceId": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.KeyVault/vaults/fergab22",
      "provisioningState": "Succeeded",
      "requestMessage": null,
      "resourceGroup": "fer-globalazure-2022",
      "type": "Microsoft.Network/privateEndpoints/privateLinkServiceConnections"
    }
  ]],
  "provisioningState": "Succeeded",
  "resourceGroup": "fer-globalazure-2022",
  "subnet": {
    "addressPrefix": null,
    "addressPrefixes": null,
    "applicationGatewayIpConfigurations": null,
    "delegations": null,
    "etag": null,
    "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/virtualNetworks/fergab22/subnets/private_endpoints",
    "ipAllocations": null,
    "ipConfigurationProfiles": null,
    "ipConfigurations": null,
    "name": null,
    "natGateway": null,
    "networkSecurityGroup": null,
    "privateEndpointNetworkPolicies": null,
    "privateEndpoints": null,
    "privateLinkServiceNetworkPolicies": null,
    "provisioningState": null,
    "purpose": null,
    "resourceGroup": "fer-globalazure-2022",
    "resourceNavigationLinks": null,
    "routeTable": null,
    "serviceAssociationLinks": null,
    "serviceEndpointPolicies": null,
    "serviceEndpoints": null,
    "type": null
  },
  "tags": null,
  "type": "Microsoft.Network/privateEndpoints"
}

# get vault NIC
$ vaultNIC=$(az network private-endpoint show --name ${n}VaultPrivateEndpoint --resource-group $rg --query networkInterfaces[[0]].id --output tsv)
@sleep 1000

# show vault NIC
$ echo $vaultNIC
/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/networkInterfaces/fergab22VaultPrivateEndpoint.nic.********-****-****-****-*********851

# get vault private ip
$ vaultIP=$(az resource show --ids $vaultNIC --api-version 2019-04-01 --query properties.ipConfigurations[[0]].properties.privateIPAddress --output tsv)
@sleep 1000

# show vault private ip
$ echo $vaultIP
10.1.0.6

# create vault dns a record
$ az network private-dns record-set a create --name $n --zone-name privatelink.vaultcore.azure.net --resource-group $rg
@sleep 1000
{
  "etag": "********-****-****-****-*********edf",
  "fqdn": "fergab22.privatelink.vaultcore.azure.net.",
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net/A/fergab22",
  "isAutoRegistered": false,
  "metadata": null,
  "name": "fergab22",
  "resourceGroup": "fer-globalazure-2022",
  "ttl": 3600,
  "type": "Microsoft.Network/privateDnsZones/A"
}

# add vault dns a record
$ az network private-dns record-set a add-record --record-set-name $n --zone-name privatelink.vaultcore.azure.net --resource-group $rg --ipv4-address $vaultIP
@sleep 1000
{
  "aRecords": [[
    {
      "ipv4Address": "10.1.0.6"
    }
  ]],
  "etag": "********-****-****-****-*********4cd",
  "fqdn": "fergab22.privatelink.azure.net.",
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io/A/fergab22",
  "isAutoRegistered": false,
  "metadata": null,
  "name": "fergab22",
  "resourceGroup": "fer-globalazure-2022",
  "ttl": 3600,
  "type": "Microsoft.Network/privateDnsZones/A"
}

# enabled aks addon for keyvault integration
$ az aks enable-addons --addons azure-keyvault-secrets-provider -g $rg -n $n
@running 10000
{
  "aadProfile": null,
  "addonProfiles": {
    "azureKeyvaultSecretsProvider": {
      "config": {
        "enableSecretRotation": "false",
        "rotationPollInterval": "2m"
      },
      "enabled": true,
      "identity": {
        "clientId": "********-****-****-****-*********4fb",
        "objectId": "********-****-****-****-*********cd7",
        "resourceId": "/subscriptions/********-****-****-****-*********16e/resourcegroups/MC_fer-globalazure-2022_fergab22_westeurope/providers/Microsoft.ManagedIdentity/userAssignedIdentities/azurekeyvaultsecretsprovider-fergab22"
      }
    }
  },
  "agentPoolProfiles": [[
    {
      "availabilityZones": null,
      "count": 2,
      "creationData": null,
      "enableAutoScaling": false,
      "enableEncryptionAtHost": false,
      "enableFips": false,
      "enableNodePublicIp": false,
      "enableUltraSsd": false,
      "gpuInstanceProfile": null,
      "kubeletConfig": null,
      "kubeletDiskType": "OS",
      "linuxOsConfig": null,
      "maxCount": null,
      "maxPods": 30,
      "minCount": null,
      "mode": "System",
      "name": "nodepool1",
      "nodeImageVersion": "AKSUbuntu-1804gen2containerd-2022.04.05",
      "nodeLabels": null,
      "nodePublicIpPrefixId": null,
      "nodeTaints": null,
      "orchestratorVersion": "1.22.6",
      "osDiskSizeGb": 128,
      "osDiskType": "Managed",
      "osSku": "Ubuntu",
      "osType": "Linux",
      "podSubnetId": null,
      "powerState": {
        "code": "Running"
      },
      "provisioningState": "Succeeded",
      "proximityPlacementGroupId": null,
      "scaleDownMode": null,
      "scaleSetEvictionPolicy": null,
      "scaleSetPriority": null,
      "spotMaxPrice": null,
      "tags": null,
      "type": "VirtualMachineScaleSets",
      "upgradeSettings": null,
      "vmSize": "Standard_B2s",
      "vnetSubnetId": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/virtualNetworks/fergab22/subnets/aks",
      "workloadRuntime": null
    }
  ]],
  "apiServerAccessProfile": null,
  "autoScalerProfile": null,
  "autoUpgradeProfile": null,
  "azurePortalFqdn": "fergab22-fer-globalazure--2a50e8-c874f727.portal.hcp.westeurope.azmk8s.io",
  "disableLocalAccounts": false,
  "diskEncryptionSetId": null,
  "dnsPrefix": "fergab22-fer-globalazure--2a50e8",
  "enablePodSecurityPolicy": null,
  "enableRbac": true,
  "extendedLocation": null,
  "fqdn": "fergab22-fer-globalazure--2a50e8-c874f727.hcp.westeurope.azmk8s.io",
  "fqdnSubdomain": null,
  "httpProxyConfig": null,
  "id": "/subscriptions/********-****-****-****-*********16e/resourcegroups/fer-globalazure-2022/providers/Microsoft.ContainerService/managedClusters/fergab22",
  "identity": {
    "principalId": "********-****-****-****-*********b08",
    "tenantId": "********-****-****-****-*********35d",
    "type": "SystemAssigned",
    "userAssignedIdentities": null
  },
  "identityProfile": {
    "kubeletidentity": {
      "clientId": "********-****-****-****-*********010",
      "objectId": "********-****-****-****-*********b47",
      "resourceId": "/subscriptions/********-****-****-****-*********16e/resourcegroups/MC_fer-globalazure-2022_fergab22_westeurope/providers/Microsoft.ManagedIdentity/userAssignedIdentities/fergab22-agentpool"
    }
  },
  "kubernetesVersion": "1.22.6",
  "linuxProfile": null,
  "location": "westeurope",
  "maxAgentPools": 100,
  "name": "fergab22",
  "networkProfile": {
    "dnsServiceIp": "10.2.0.10",
    "dockerBridgeCidr": "172.17.0.1/16",
    "ipFamilies": [[
      "IPv4"
    ]],
    "loadBalancerProfile": {
      "allocatedOutboundPorts": null,
      "effectiveOutboundIPs": [[
        {
          "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/MC_fer-globalazure-2022_fergab22_westeurope/providers/Microsoft.Network/publicIPAddresses/********-****-****-****-*********3a1",
          "resourceGroup": "MC_fer-globalazure-2022_fergab22_westeurope"
        }
      ]],
      "enableMultipleStandardLoadBalancers": null,
      "idleTimeoutInMinutes": null,
      "managedOutboundIPs": {
        "count": 1,
        "countIpv6": null
      },
      "outboundIPs": null,
      "outboundIpPrefixes": null
    },
    "loadBalancerSku": "Standard",
    "natGatewayProfile": null,
    "networkMode": null,
    "networkPlugin": "azure",
    "networkPolicy": null,
    "outboundType": "loadBalancer",
    "podCidr": null,
    "podCidrs": null,
    "serviceCidr": "10.2.0.0/16",
    "serviceCidrs": [[
      "10.2.0.0/16"
    ]]
  },
  "nodeResourceGroup": "MC_fer-globalazure-2022_fergab22_westeurope",
  "podIdentityProfile": null,
  "powerState": {
    "code": "Running"
  },
  "privateFqdn": null,
  "privateLinkResources": null,
  "provisioningState": "Succeeded",
  "publicNetworkAccess": null,
  "resourceGroup": "fer-globalazure-2022",
  "securityProfile": {
    "azureDefender": null
  },
  "servicePrincipalProfile": {
    "clientId": "msi",
    "secret": null
  },
  "sku": {
    "name": "Basic",
    "tier": "Free"
  },
  "systemData": null,
  "tags": null,
  "type": "Microsoft.ContainerService/ManagedClusters",
  "windowsProfile": {
    "adminPassword": null,
    "adminUsername": "azureuser",
    "enableCsiProxy": true,
    "gmsaProfile": null,
    "licenseType": null
  }
}

# search identity object id
$ aks_object_id=$(az aks show -g $rg -n $n --query identityProfile.kubeletidentity.objectId -o tsv)

# create read policy for identity
$ az keyvault set-policy --name $n --object-id $aks_object_id --secret-permissions get list --key-permissions get list --certificate-permissions get list
@sleep 2000
{
  "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.KeyVault/vaults/fergab22",
  "location": "westeurope",
  "name": "fergab22",
  "properties": {
    "accessPolicies": [[
      {
        "applicationId": null,
        "objectId": "********-****-****-****-*********2da",
        "permissions": {
          "certificates": [[
            "all"
          ]],
          "keys": [[
            "all"
          ]],
          "secrets": [[
            "all"
          ]],
          "storage": [[
            "all"
          ]]
        },
        "tenantId": "********-****-****-****-*********35d"
      },
      {
        "applicationId": null,
        "objectId": "********-****-****-****-*********f8b",
        "permissions": {
          "certificates": [[
            "list",
            "get"
          ]],
          "keys": [[
            "list",
            "get"
          ]],
          "secrets": [[
            "list",
            "get"
          ]],
          "storage": null
        },
        "tenantId": "********-****-****-****-*********35d"
      }
    ]],
    "createMode": null,
    "enablePurgeProtection": null,
    "enableRbacAuthorization": null,
    "enableSoftDelete": true,
    "enabledForDeployment": false,
    "enabledForDiskEncryption": null,
    "enabledForTemplateDeployment": null,
    "hsmPoolResourceId": null,
    "networkAcls": {
      "bypass": "AzureServices",
      "defaultAction": "Deny",
      "ipRules": [[
        {
          "value": "***.***.***.***/32"
        }
      ]],
      "virtualNetworkRules": [[]]
    },
    "privateEndpointConnections": [[
      {
        "etag": null,
        "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.KeyVault/vaults/fergab22/privateEndpointConnections/fergab22VaultConnection",
        "privateEndpoint": {
          "id": "/subscriptions/********-****-****-****-*********16e/resourceGroups/fer-globalazure-2022/providers/Microsoft.Network/privateEndpoints/fergab22VaultPrivateEndpoint",
          "resourceGroup": "fer-globalazure-2022"
        },
        "privateLinkServiceConnectionState": {
          "actionsRequired": "None",
          "description": null,
          "status": "Approved"
        },
        "provisioningState": "Succeeded",
        "resourceGroup": "fer-globalazure-2022"
      }
    ]],
    "provisioningState": "Succeeded",
    "publicNetworkAccess": "Enabled",
    "sku": {
      "family": "A",
      "name": "standard"
    },
    "softDeleteRetentionInDays": 90,
    "tenantId": "********-****-****-****-*********35d",
    "vaultUri": "https://fergab22.vault.azure.net/"
  },
  "resourceGroup": "fer-globalazure-2022",
  "systemData": {
    "createdAt": "2022-05-07T10:00:50.225000+00:00",
    "createdBy": "********-****-****-****-*********469",
    "createdByType": "Application",
    "lastModifiedAt": "2022-05-07T10:00:20.075000+00:00",
    "lastModifiedBy": "********-****-****-****-*********469",
    "lastModifiedByType": "Application"
  },
  "tags": {},
  "type": "Microsoft.KeyVault/vaults"
}

# connect to aks
$ az aks get-credentials --resource-group $rg --name $n
[yellow]Merged "fergab22" as current context in /root/.kube/config[/]

# add nginx helm repo
$ helm repo add nginx https://kubernetes.github.io/ingress-nginx
"nginx" has been added to your repositories

# update helm repo
$ helm repo update
@sleep 100
Hang tight while we grab the latest from your chart repositories...
@sleep 100
...Successfully got an update from the "nginx" chart repository
@sleep 100
Update Complete. ⎈Happy Helming!⎈

# install nginx ingress controller
$ helm upgrade ingress-nginx nginx/ingress-nginx --namespace nginx --create-namespace --install
Release "ingress-nginx" does not exist. Installing it now.
@sleep 2000
NAME: ingress-nginx
LAST DEPLOYED: Sat May  7 10:00:09 2022
NAMESPACE: nginx
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The ingress-nginx controller has been installed.
It may take a few minutes for the LoadBalancer IP to be available.
You can watch the status by running 'kubectl --namespace nginx get services -o wide -w ingress-nginx-controller'

An example Ingress that makes use of the controller:
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: example
    namespace: foo
  spec:
    ingressClassName: nginx
    rules:
      - host: www.example.com
        http:
          paths:
            - pathType: Prefix
              backend:
                service:
                  name: exampleService
                  port:
                    number: 80
              path: /
    # This section is only required if TLS is to be enabled for the Ingress
    tls:
      - hosts:
        - www.example.com
        secretName: example-tls

If TLS is enabled for the Ingress, a Secret containing the certificate and key must also be provided:

  apiVersion: v1
  kind: Secret
  metadata:
    name: example-tls
    namespace: foo
  data:
    tls.crt: <base64 encoded cert>
    tls.key: <base64 encoded key>
  type: kubernetes.io/tls

# add prometheus community helm repo
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
"prometheus-community" has been added to your repositories

# update helm repos
$ helm repo update
@sleep 100
Hang tight while we grab the latest from your chart repositories...
@sleep 100
...Successfully got an update from the "nginx" chart repository
@sleep 100
...Successfully got an update from the "prometheus-community" chart repository
@sleep 100
Update Complete. ⎈Happy Helming!⎈

# install prometheus stack
$ helm upgrade prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace --install
Release "prometheus" does not exist. Installing it now.
@sleep 2000
NAME: prometheus
LAST DEPLOYED: Sat May  7 10:00:47 2022
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
NOTES:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace monitoring get pods -l "release=prometheus"

Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.

# check running pods
$ k get pods -A
NAMESPACE     NAME                                                     READY   STATUS    RESTARTS   AGE
kube-system   aks-secrets-store-csi-driver-86z8q                       3/3     Running   0          26m
kube-system   aks-secrets-store-csi-driver-fffp8                       3/3     Running   0          26m
kube-system   aks-secrets-store-provider-azure-8k8r6                   1/1     Running   0          26m
kube-system   aks-secrets-store-provider-azure-dnhpr                   1/1     Running   0          26m
kube-system   azure-ip-masq-agent-ck4bj                                1/1     Running   0          62m
kube-system   azure-ip-masq-agent-gvd5k                                1/1     Running   0          63m
kube-system   cloud-node-manager-b7rxh                                 1/1     Running   0          62m
kube-system   cloud-node-manager-d8jtj                                 1/1     Running   0          63m
kube-system   coredns-69c47794-h8f7p                                   1/1     Running   0          64m
kube-system   coredns-69c47794-jmxgs                                   1/1     Running   0          62m
kube-system   coredns-autoscaler-7d56cd888-8zrrq                       1/1     Running   0          64m
kube-system   csi-azuredisk-node-wnt87                                 3/3     Running   0          63m
kube-system   csi-azuredisk-node-xb2tg                                 3/3     Running   0          62m
kube-system   csi-azurefile-node-qjt56                                 3/3     Running   0          62m
kube-system   csi-azurefile-node-srzsj                                 3/3     Running   0          63m
kube-system   kube-proxy-m4p6h                                         1/1     Running   0          63m
kube-system   kube-proxy-xh7p5                                         1/1     Running   0          62m
kube-system   metrics-server-6576d9ccf8-7h442                          1/1     Running   0          64m
kube-system   tunnelfront-69fb8d69c9-z7k7h                             1/1     Running   0          13m
monitoring    alertmanager-prometheus-kube-prometheus-alertmanager-0   2/2     Running   0          2m47s
monitoring    prometheus-grafana-6c5f6cf68-qltjh                       3/3     Running   0          2m52s
monitoring    prometheus-kube-prometheus-operator-6679c85d9b-4dmjx     1/1     Running   0          2m52s
monitoring    prometheus-kube-state-metrics-77698656df-vv5k8           1/1     Running   0          2m52s
monitoring    prometheus-prometheus-kube-prometheus-prometheus-0       2/2     Running   0          2m46s
monitoring    prometheus-prometheus-node-exporter-247cr                1/1     Running   0          2m52s
monitoring    prometheus-prometheus-node-exporter-bsmxm                1/1     Running   0          2m52s
nginx         ingress-nginx-controller-5849c9f946-xmms4                1/1     Running   0          7m47s

# ACR docker login
$ docker login fergab22.azurecr.io -u $user -p $password
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
WARNING! Your password will be stored unencrypted in /home/fernando/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
@sleep 1000

Login Succeeded

# build myapi last version
$ docker build -t fergab22.azurecr.io/myapi:1.0 .
@sleep 100
Sending build context to Docker daemon  5.456MB
@sleep 100
Step 1/8 : FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
@sleep 100
 ---> c74c8a7a6bd2
Step 2/8 : WORKDIR /src
 ---> Using cache
 ---> 092fa94b6aa8
Step 3/8 : COPY . .
 ---> 6c0e90e18ebb
Step 4/8 : RUN dotnet publish "MyApi/MyApi.csproj" -c Release -o /app
@sleep 200
 ---> Running in e7754ca39ff3
Microsoft (R) Build Engine version 17.1.1+a02f73656 for .NET
Copyright (C) Microsoft Corporation. All rights reserved.

  Determining projects to restore...
@sleep 200
  Restored /src/MyApi/MyApi.csproj (in 3.05 sec).
  MyApi -> /src/MyApi/bin/Release/net6.0/MyApi.dll
  MyApi -> /app/
@sleep 100
Removing intermediate container e7754ca39ff3
 ---> 07bbc96e2e2b
Step 5/8 : FROM mcr.microsoft.com/dotnet/aspnet:6.0
 ---> 6072cf97f95e
Step 6/8 : WORKDIR /app
@sleep 100
 ---> Using cache
 ---> ee420d22b4d7
Step 7/8 : COPY --from=build /app ./
 ---> da726317cc65
Step 8/8 : ENTRYPOINT [["dotnet", "MyApi.dll"]]
 ---> Running in 5dd5198238af
@sleep 100
Removing intermediate container 5dd5198238af
 ---> e71e10e8883a
@sleep 100
Successfully built e71e10e8883a
@sleep 100
Successfully tagged fergab22.azurecr.io/myapi:1.0

# push new image to acr
$ docker push fergab22.azurecr.io/myapi:1.0
The push refers to repository [[fergab22.azurecr.io/myapi]]
@sleep 2000
118580463678: Pushed
@sleep 100
a88e7fb8f5d0: Layer already exists
@sleep 100
a45a618792f0: Layer already exists
@sleep 100
6c946b32cfe2: Layer already exists
@sleep 100
7dd4a3e7d836: Layer already exists
@sleep 100
20147d2db13c: Layer already exists
@sleep 100
9c1b6dd6c1e6: Layer already exists
@sleep 100
1.0: digest: sha256:c72dcbe9a1a9817e5c22e69d8a2be92016b5b4131179f493ec283a64f4089101 size: 1789

# create api namespace
$ k create namespace my-api
namespace/my-api created

# apply all k8s resources
$ k apply -f deployment.yaml -n my-api
@sleep 100
configmap/my-app-config created
@sleep 100
secretproviderclass.secrets-store.csi.x-k8s.io/azure-kv-secret created
@sleep 100
deployment.apps/my-api created
@sleep 100
service/my-api-service created
@sleep 100
ingress.networking.k8s.io/my-api-ingress created
