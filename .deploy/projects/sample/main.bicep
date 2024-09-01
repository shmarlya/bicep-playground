import {createResourceGroupName, createShortTenantName, createFullTenantName, createAppServiceName, createStorageName, createCongitiveServiceName, createDefaultWebAppDomain, createB2CapplicationRedirectUri, createCertificateName, createManagedIdentityName, createKVName, createCertificateSubject} from '../../functions/resource-names.bicep'

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
var project = config.PROEJCTS[0]
var projectName = project.PROJECT_NAME
var env = project.ENVIRONMENTS[0]
var envName = env.envName
var subscriptionId = env.subsciprtionId
var resourceGroupName = createResourceGroupName(projectName, location, envName)
var keyVaultName = createKVName(projectName, envName)
// ====================================== MODULES ============================================== //

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
  scope: resourceGroup(subscriptionId, resourceGroupName )
}

module resourcesWrapperModule '../../resources/resources.bicep' = {
  name: 'resourcesWrapperModule-${env}'
  scope: resourceGroup(resourceGroupName)
  params: {
    env: envName
    appServicePlanName: createAppServiceName(projectName, location, envName)
    tenantName: createShortTenantName(projectName, envName)
    storageName: createStorageName(projectName, envName)
    congitiveServiceName: createCongitiveServiceName(projectName, envName)
    WEB_APP_DOMAIN: createDefaultWebAppDomain(createShortTenantName(projectName, envName))
    B2C_REDIRECT_URL: createB2CapplicationRedirectUri(createShortTenantName(projectName, envName))
    FULL_TENANT_NAME: createFullTenantName(createShortTenantName(projectName, envName))
    webIdentityPrincipalId: kv.getSecret('webIdentityPrincipalId')
    certificateName: createCertificateName(projectName, envName)
    certificateSubject: createCertificateSubject(createDefaultWebAppDomain(createShortTenantName(projectName, envName)))
    keyVaultName: createKVName(projectName, envName)
  }
}
// ====================================== OUTPUT =============================================== //
// ====================================== EXECUTE ============================================== //
// !!important for test purposes env hardcoded to var env = config.ENVIRONMENTS[0]
// !!important once you modify directory to real project name - dont forget to change template file path
// !!important for each env better to create copy this file
// az deployment sub create --name projectMainEnvDeployment --location eastus --template-file "./.deploy/projects/sample/main.bicep"
