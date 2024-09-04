// Create KV and grant the webIdentity MSI access to the KV
param keyVaultName string
param objectId string
@secure()
param WEB_IDENTITY_PRINCIPAL_ID string
param tenantId string
param location string = resourceGroup().location

param enableRbacAuthorization bool = true
param enabledForDeployment bool = true
param enabledForTemplateDeployment bool = true
param enabledForDiskEncryption bool = true

var roleIdMapping = {
  'Key Vault Administrator': '00482a5a-887f-4fb3-b363-3b7fe8e74483'
  'Key Vault Certificates Officer': 'a4417e6f-fecd-4de8-b567-7b0420556985'
  'Key Vault Crypto Officer': '14b46e9e-c2b7-41b4-b07b-48a6ebf60603'
  'Key Vault Crypto Service Encryption User': 'e147488a-f6f5-4113-8e2d-b22465e65bf6'
  'Key Vault Crypto User': '12338af0-0e69-4776-bea7-57ae8d297424'
  'Key Vault Reader': '21090545-7ca7-4776-b22c-e363652d74d2'
  'Key Vault Secrets Officer': 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
  'Key Vault Secrets User': '4633458b-17de-408a-b874-0445c86b69e6'
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: tenantId
    enableRbacAuthorization: enableRbacAuthorization
    enabledForDeployment: enabledForDeployment
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}


resource kvUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(roleIdMapping['Key Vault Administrator'], objectId, keyVault.id)
  scope: keyVault
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleIdMapping['Key Vault Administrator'])
    principalId: objectId
    principalType: 'User'
  }
}

resource kvMIRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(roleIdMapping['Key Vault Administrator'], WEB_IDENTITY_PRINCIPAL_ID, keyVault.id)
  scope: keyVault
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleIdMapping['Key Vault Administrator'])
    principalId: WEB_IDENTITY_PRINCIPAL_ID
    principalType: 'ServicePrincipal'
  }
}

resource secretIdentityId 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'WEB_IDENTITY_PRINCIPAL_ID'
  properties: {
    value: 'WEB_IDENTITY_PRINCIPAL_ID'
    attributes: {
      enabled: true
    }
  }
}
