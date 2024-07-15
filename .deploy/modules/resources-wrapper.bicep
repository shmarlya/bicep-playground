import {createStorageName, createResourceGroupName, createAppServiceName, createWebAppName, createTenantName, createDefaultWebAppDomain, createCongitiveServiceName} from './funcs.bicep'

targetScope = 'tenant'

param firstTimeDeploy bool
param subscriptionId string
param projectName string
param location string
param PORT string
param SOCKET_PORT string
param STRIPE_SECRET string
param STRIPE_WEBHOOK_SECRET string

@allowed(
  [
    'dev'
    'prod'
  ]
)
param env string

var resourceGroupName = createResourceGroupName(projectName, location, env)
module rgModule './rg/rsrc-group.bicep' =  {
  name: 'rgModule-${env}'
  scope: subscription(subscriptionId)
  params: {
    location: location
    resourceGroupName: resourceGroupName
  }
}


param countryCode string
param tenantRegion string
var tenantName = createTenantName(projectName, env)
module tenantModule './tenant/tenant.bicep' = if(firstTimeDeploy){
  name: 'tenantModule-${env}'
  dependsOn: [rgModule]
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    projectName: projectName
    tenantName:tenantName
    countryCode: countryCode
    tenantRegion: tenantRegion
  }
}



// module appsModule './apps/apps.bicep' = {
//   name: 'appsModule'
//   dependsOn: [rgModule, tenantModule]
//   scope: resourceGroup(subscriptionId, resourceGroupName)
//   params: {
//     projectName: projectName
//     DOMAIN_NAME: DOMAIN_NAME
//   }
// }


var appServicePlanName = createAppServiceName(projectName, location, env)
var webAppName = createWebAppName(projectName, env)
var storageName = createStorageName(projectName, env)
var congitiveServiceName = createCongitiveServiceName(projectName, env)
var DOMAIN_NAME = createDefaultWebAppDomain(webAppName)
module resourcesModule './resources.bicep' = {
  name: 'resourcesModule-${env}'
  dependsOn: [rgModule]
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    env: env
    appServicePlanName: appServicePlanName
    webAppName: webAppName
    storageName: storageName
    DOMAIN_NAME: DOMAIN_NAME
    PORT: PORT
    SOCKET_PORT: SOCKET_PORT
    STRIPE_SECRET: STRIPE_SECRET
    STRIPE_WEBHOOK_SECRET: STRIPE_WEBHOOK_SECRET
    congitiveServiceName: congitiveServiceName
  }
}

