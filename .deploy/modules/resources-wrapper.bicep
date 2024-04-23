import {createStorageName, createResourceGroupName, createAppServiceName, createWebAppName, createTenantName} from './funcs.bicep'

targetScope = 'tenant'

param firstTimeDeploy bool
param subscriptionId string
param projectName string
param location string

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

var appServicePlanName = createAppServiceName(projectName, location, env)
var webAppName = createWebAppName(projectName, env)
var storageName = createStorageName(projectName)
module resourcesModule './resources.bicep' = {
  name: 'resourcesModule-${env}'
  dependsOn: [rgModule]
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    env: env
    appServicePlanName: appServicePlanName
    webAppName: webAppName
    storageName: storageName
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
    tenantName:tenantName
    countryCode: countryCode
    tenantRegion: tenantRegion
  }
}
