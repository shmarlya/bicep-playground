
param identityName string
param location string = resourceGroup().location

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
}

output WEB_IDENTITY_PRINCIPAL_ID string = managedIdentity.properties.principalId
output managedIdentityId string = managedIdentity.id
