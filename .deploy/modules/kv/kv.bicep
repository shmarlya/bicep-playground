// Create KV and grant the webIdentity MSI access to the KV
param keyVaultName string
param webIdentityPrincipalId string
param location string = resourceGroup().location

@description('Specifies the permissions to keys in the vault. Valid values are described in https://learn.microsoft.com/azure/templates/microsoft.keyvault/vaults?pivots=deployment-language-bicep#permissions')
param keysPermissions array = [
  'list'
]
@description('Specifies the permissions to secrets in the vault. Valid values are described in https://learn.microsoft.com/azure/templates/microsoft.keyvault/vaults?pivots=deployment-language-bicep#permissions')
param secretsPermissions array = [
  'list'
  'get'
]

@description('Specifies the permissions to certificates in the vault. Valid values are described in https://learn.microsoft.com/azure/templates/microsoft.keyvault/vaults?pivots=deployment-language-bicep#permissions')
param certificatesPermissions array = [
  'get'
  'list'
  'update'
  'create'
]

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
    accessPolicies: [
      {
        objectId: webIdentityPrincipalId
        tenantId: subscription().tenantId
        permissions: {
          keys: keysPermissions
          secrets: secretsPermissions
          certificates: certificatesPermissions
        }
      }
    ]
  }
}
