targetScope = 'resourceGroup'


param tenantName string

@allowed(
  [
    'PL'
    'US'
  ]
)
param countryCode string

@allowed([
  'global'
  'unitedstates'
  'europe'
])
param tenantRegion string

resource tenant 'Microsoft.AzureActiveDirectory/b2cDirectories@2021-04-01' = {
  name: tenantName
  location: tenantRegion
  sku: {
    name: 'Standard'
    tier: 'A0'
  }
  properties: {
    createTenantProperties: {
      countryCode: countryCode
      displayName: tenantName
    }
  }
}
