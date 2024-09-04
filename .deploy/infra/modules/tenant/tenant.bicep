targetScope = 'resourceGroup'

// ====================================== PARAMETERS =========================================== //
@description('should be xxxxxxxx.onmicrosoft.com')
param fullTenantName string
@allowed(
  [
    'PL'
    'US'
  ]
)
param countryCode string
@allowed([
  'United States'
  'Europe'
])
param tenantRegion string

// ====================================== RESOURCES ============================================ //
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

// ====================================== OUTPUT =============================================== //
output tenantId string = tenant.properties.tenantId
