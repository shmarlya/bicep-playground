targetScope = 'resourceGroup'

param keyVaultName string = 'mykv${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location
param tenantId string


resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForTemplateDeployment: true
    tenantId: tenantId
    accessPolicies: [
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}
