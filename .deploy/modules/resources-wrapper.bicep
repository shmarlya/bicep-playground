targetScope = 'subscription'

param firstTimeDeploy bool
param subscriptionId string
param location string
param PORT string
param SOCKET_PORT string
param STRIPE_SECRET string
param STRIPE_WEBHOOK_SECRET string
param env string
param projectName string
param resourceGroupName string
param countryCode string
param tenantRegion string
param fullTenantName string
param appServicePlanName string
param webAppName string
param storageName string
param congitiveServiceName string
param WEB_APP_DOMAIN string
param B2C_REDIRECT_URL string
module rgModule './rg/rsrc-group.bicep' =  {
  name: 'rgModule-${env}'
  scope: subscription(subscriptionId)
  params: {
    location: location
    resourceGroupName: resourceGroupName
  }
}

module tenantModule './tenant/tenant.bicep' = if(firstTimeDeploy){
  name: 'tenantModule-${env}'
  dependsOn: [rgModule]
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    fullTenantName:fullTenantName
    countryCode: countryCode
    tenantRegion: tenantRegion
  }
}

module appsModule './apps/apps.bicep' = {
  name: 'appsModule'
  dependsOn: [rgModule, tenantModule]
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    projectName: projectName
    B2C_REDIRECT_URL:B2C_REDIRECT_URL
  }
}

module resourcesModule './resources.bicep' = {
  name: 'resourcesModule-${env}'
  dependsOn: [rgModule, tenantModule]
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    env: env
    appServicePlanName: appServicePlanName
    webAppName: webAppName
    storageName: storageName
    WEB_APP_DOMAIN: WEB_APP_DOMAIN
    PORT: PORT
    SOCKET_PORT: SOCKET_PORT
    STRIPE_SECRET: STRIPE_SECRET
    STRIPE_WEBHOOK_SECRET: STRIPE_WEBHOOK_SECRET
    congitiveServiceName: congitiveServiceName
    B2C_REDIRECT_URL: B2C_REDIRECT_URL
  }
}

