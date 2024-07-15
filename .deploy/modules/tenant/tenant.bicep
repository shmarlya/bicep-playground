import {createB2CapplicationRedirectUri} from '../funcs.bicep'

targetScope = 'resourceGroup'
provider microsoftGraph

param projectName string
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

var IdentityExperienceFramework_NAME = 'IdentityExperienceFramework'
var IdentityExperienceFramework_REDIRECT_URI = createB2CapplicationRedirectUri(projectName)

resource IdentityExperienceFramework_APP 'Microsoft.Graph/applications@v1.0' = {
  dependsOn: [tenant]
  uniqueName: IdentityExperienceFramework_NAME
  displayName: IdentityExperienceFramework_NAME
  signInAudience: 'AzureADMyOrg'
  web: {
    redirectUris: [IdentityExperienceFramework_REDIRECT_URI]
  }
}
