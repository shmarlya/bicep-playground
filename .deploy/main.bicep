
import { createB2CapplicationRedirectUri, createDefaultWebAppDomain, createStorageName, createWebAppName, createAppServiceName, createResourceGroupName, createFullTenantName, createCongitiveServiceName, createShortTenantName} from './modules/funcs.bicep'

// az login --tenant xxxxxx
// az deployment sub create --name mainDeployment --location eastus --template-file "./.deploy/main.bicep" --parameters "./.deploy/main.bicepparam"


targetScope = 'subscription'
// ====================================== PARAMETERS =========================================== //
param firstTimeDeploy bool
param orgSubscriptionId string
param projectName string
param location string = deployment().location
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
param PORT string
param SOCKET_PORT string
param STRIPE_SECRET string
param STRIPE_WEBHOOK_SECRET string


param billingAccountName string = 'ee4560a8-392b-553d-ad5c-83ad17a80ebf:bf0373bb-5c81-4391-a463-242fbc9728ae_2019-05-31'
param billingProfileName string = 'SUQ3-EI2M-BG7-PGB'
param invoiceSectionName string = 'IL3H-IWNK-PJA-PGB'
param subscriptionTenantId string
// ====================================== VARIABLES =========================================== //
var config = loadJsonContent('./config.json')

// ====================================== PROJECT IAC =========================================== //
module projectSubscription './modules/sub/subscription.tenant.bicep' = {
  name: 'rootSubscriptionModule'
  scope: tenant()
  params: {
    subscriptionName: 'test'
    subscriptionTenantId: subscriptionTenantId
    billingProfileName: billingProfileName
    invoiceSectionName: invoiceSectionName
    billingAccountName: billingAccountName
  }
}
// module resourcesWrapperModule './modules/resources-wrapper.bicep' = [for (env, i) in config.ENVIRONMENTS: {
//   name: 'resourcesWrapperModule-${env}'
//   scope: subscription(orgSubscriptionId)
//   params: {
//     firstTimeDeploy: firstTimeDeploy
//     env:env
//     subscriptionId: orgSubscriptionId
//     location: location
//     projectName: projectName
//     countryCode: countryCode
//     tenantRegion: tenantRegion
//     PORT: PORT
//     SOCKET_PORT: SOCKET_PORT
//     STRIPE_SECRET: STRIPE_SECRET
//     STRIPE_WEBHOOK_SECRET: STRIPE_WEBHOOK_SECRET
//     resourceGroupName: createResourceGroupName(projectName, location, env)
//     fullTenantName: createFullTenantName(createShortTenantName(projectName, env))
//     appServicePlanName: createAppServiceName(projectName, location, env)
//     webAppName: createWebAppName(projectName, env)
//     storageName: createStorageName(projectName, env)
//     congitiveServiceName: createCongitiveServiceName(projectName, env)
//     WEB_APP_DOMAIN: createDefaultWebAppDomain(createWebAppName(projectName, env))
//     B2C_REDIRECT_URL: createB2CapplicationRedirectUri(projectName)
//   }
// }]


