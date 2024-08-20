import {createResourceGroupName, createShortTenantName, createFullTenantName, createAppServiceName, createStorageName, createCongitiveServiceName, createDefaultWebAppDomain, createB2CapplicationRedirectUri} from '../../functions/resource-names.bicep'

targetScope = 'subscription'
// ====================================== BRIEF DESCRIPTION ==================================== //
// creates project env resources and azure b2c apps
// ====================================== GETTING STARTED ====================================== //
// deployed parents
// !!important assign Cognitive Services Contributor to your user before
// !!important you have to assign AI terms in azure portal subscription before deploy - for doing that you have manually create ai resource???(not sure if that only way)
// az account set --subscription xxxxxxxxxxxxxxx
// ====================================== PARAMETERS =========================================== //
// ====================================== VARIABLES ============================================ //
var config = loadJsonContent('../../config.json')
var location = deployment().location
var projectName = config.PROJECT_NAME
var env = config.ENVIRONMENTS[0]
var resourceGroupName = createResourceGroupName(projectName, location, env)
// ====================================== MODULES ============================================== //
module projectEnvRGModule '../../modules/rg/resource-group.bicep' = {
  name: 'projectEnvRGModule'
  params: {
    location: location
    resourceGroupName: resourceGroupName
  }
}

module resourcesWrapperModule '../../resources/resources.bicep' = {
  name: 'resourcesWrapperModule-${env}'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [projectEnvRGModule]
  params: {
    env:env
    PORT: config.PROJECT[env].params.PORT
    SOCKET_PORT: config.PROJECT[env].params.SOCKET_PORT
    STRIPE_SECRET: config.PROJECT[env].params.STRIPE_SECRET
    STRIPE_WEBHOOK_SECRET: config.PROJECT[env].params.STRIPE_WEBHOOK_SECRET
    appServicePlanName: createAppServiceName(projectName, location, env)
    tenantName: createShortTenantName(projectName, env)
    storageName: createStorageName(projectName, env)
    congitiveServiceName: createCongitiveServiceName(projectName, env)
    WEB_APP_DOMAIN: createDefaultWebAppDomain(createShortTenantName(projectName, env))
    B2C_REDIRECT_URL: createB2CapplicationRedirectUri(createShortTenantName(projectName, env))
    FULL_TENANT_NAME: createFullTenantName(createShortTenantName(projectName, env))
  }
}
// ====================================== OUTPUT =============================================== //
// ====================================== EXECUTE ============================================== //
// !!important for test purposes env hardcoded to var env = config.ENVIRONMENTS[0]
// !!important once you modify directory to real project name - dont forget to change template file path
// !!important for each env better to create copy this file
// az deployment sub create --name projectMainEnvDeployment --location eastus --template-file "./.deploy/projects/sample/main.bicep"
