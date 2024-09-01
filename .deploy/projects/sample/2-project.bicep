import {createResourceGroupName, createShortTenantName, createFullTenantName} from '../../functions/resource-names.bicep'
targetScope = 'tenant'
// ====================================== BRIEF DESCRIPTION ==================================== //
// creating project env tenant in enviroment project resource group
// ====================================== GETTING STARTED ====================================== //
// successfull deployed parents
// you have to be under root organization subscription context
// az account set --subscription xxxxxxxxxxxxxxx
// ====================================== PARAMETERS =========================================== //
param location string = deployment().location
// ====================================== VARIABLES ============================================ //
var config = loadJsonContent('../../config.json')
var project = config.PROEJCTS[0]
var projectName = project.PROJECT_NAME
var rootOrganizationSubscriptionId = config.ORG_SUBSCRIPTION_ID
var countryCode = config.ORG_COUNTRY_CODE
var tenantRegion = config.ORG_TENANT_REGION
// ====================================== MODULES ============================================== //
module projectTenant '../../modules/tenant/tenant.bicep' = [for (env, i) in project.ENVIRONMENTS: {
  name: 'projectTenant-${projectName}-${env}'
  scope: resourceGroup(rootOrganizationSubscriptionId, createResourceGroupName(projectName, location, env.envName))
  params: {
    fullTenantName: createFullTenantName(createShortTenantName(projectName, env.envName))
    countryCode: countryCode
    tenantRegion: tenantRegion
  }
}]
// ====================================== OUTPUT =============================================== //
// ====================================== EXECUTE ============================================== //
// az deployment tenant create --name projectTenantEnvDeployment --location eastus --template-file "./.deploy/projects/sample/2-project.bicep"
