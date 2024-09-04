import {createResourceGroupName, createShortTenantName, createFullTenantName, createAppServiceName, createStorageName, createCongitiveServiceName, createDefaultWebAppDomain, createB2CapplicationRedirectUri, createCertificateName, createManagedIdentityName, createKVName, createCertificateSubject, createFullGitHubRepoURL, createGitSubjectIdentifier} from '../../../infra/functions/resource-names.bicep'

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
var config = loadJsonContent('../../../config.json')
var secrets = loadJsonContent('../../../secrets.json')
var location = deployment().location
var project = config.PROJECTS[0]
var projectName = project.PROJECT_NAME
var env = project.ENVIRONMENTS[0]
var envName = env.PROJECT_ENV_NAME
var PROJECT_ENV_BRANCH_NAME = env.PROJECT_ENV_BRANCH_NAME
var resourceGroupName = createResourceGroupName(projectName, location, envName)
var GITHUB_ACTIONS_SUBJECT = createGitSubjectIdentifier(project.PROJECT_REPOSITORY_ORG_NAME, project.PROJECT_REPOSITORY_NAME, env.PROJECT_ENV_BRANCH_NAME)
var FULL_GITHUB_PROJECT_REPOSITORY = createFullGitHubRepoURL(project.PROJECT_REPOSITORY_ORG_NAME, project.PROJECT_REPOSITORY_NAME)
// ====================================== MODULES ============================================== //

module projectEnvRGModule '../../../infra/modules/rg/resource-group.bicep' = {
  name: 'projectSubscription-${projectName}-${env.PROJECT_ENV_NAME}'
  scope: subscription(env.PROJECT_ENV_SUBSCRIPTION_ID)
  params: {
    location: location
    resourceGroupName: resourceGroupName
  }
}

// module webIdentityModule '../../modules/managedIdentity/userAssigned.bicep' = {
//   name: 'webIdentityModule-${projectName}-${env.PROJECT_ENV_NAME}'
//   dependsOn: [projectEnvRGModule]
//   scope: resourceGroup(resourceGroupName)
//   params: {
//     identityName: resourceGroupName
//   }
// }

module resourcesWrapperModule '../../../infra/resources/resources.bicep' = {
  name: 'resourcesWrapperModule-${envName}'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [projectEnvRGModule]
  params: {
    env: envName
    appServicePlanName: createAppServiceName(projectName, location, envName)
    tenantName: createShortTenantName(projectName, envName)
    storageName: createStorageName(projectName, envName)
    congitiveServiceName: createCongitiveServiceName(projectName, envName)
    WEB_APP_DOMAIN: createDefaultWebAppDomain(createShortTenantName(projectName, envName))
    B2C_REDIRECT_URL: createB2CapplicationRedirectUri(createShortTenantName(projectName, envName))
    FULL_TENANT_NAME: createFullTenantName(createShortTenantName(projectName, envName))
    PROJECT_ENV_BRANCH_NAME: PROJECT_ENV_BRANCH_NAME
    GITHUB_ACTIONS_SUBJECT: GITHUB_ACTIONS_SUBJECT
    FULL_GITHUB_PROJECT_REPOSITORY: FULL_GITHUB_PROJECT_REPOSITORY
    PORT: secrets.PORT
    SOCKET_PORT: secrets.SOCKET_PORT
    STRIPE_SECRET: secrets.STRIPE_SECRET
    STRIPE_WEBHOOK_SECRET: secrets.STRIPE_WEBHOOK_SECRET
    B2C_SERVER_APPLICATION_SECRET: secrets.B2C_SERVER_APPLICATION_SECRET

    // certificateName: createCertificateName(projectName, envName)
    // certificateSubject: createCertificateSubject(createDefaultWebAppDomain(createShortTenantName(projectName, envName)))
    // keyVaultName: createKVName(projectName, envName)
    // WEB_IDENTITY_PRINCIPAL_ID: webIdentityModule.outputs.WEB_IDENTITY_PRINCIPAL_ID
  }
}
// ====================================== OUTPUT =============================================== //
// ====================================== EXECUTE ============================================== //
// !!important for test purposes env hardcoded to var env = config.ENVIRONMENTS[0]
// az deployment sub create --name projectMainEnvDeployment --location eastus --template-file "./.deploy/projects/sample/main.bicep"
