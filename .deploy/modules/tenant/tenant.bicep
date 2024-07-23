targetScope = 'resourceGroup'

param fullTenantName string

@allowed(
  [
    'PL'
    'US'
  ]
)
param countryCode string


param tenantRegion string

resource tenant 'Microsoft.AzureActiveDirectory/b2cDirectories@2021-04-01' = {
  name: fullTenantName
  location: tenantRegion
  sku: {
    name: 'Standard'
    tier: 'A0'
  }
  properties: {
    createTenantProperties: {
      countryCode: countryCode
      displayName: fullTenantName
    }
  }
}

output tenantId string = tenant.properties.tenantId
