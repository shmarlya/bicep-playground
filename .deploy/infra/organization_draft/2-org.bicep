import {createShortTenantName, createFullTenantName, createResourceGroupName} from '../functions/resource-names.bicep'

targetScope = 'tenant'
// ====================================== BRIEF DESCRIPTION ==================================== //
// creating root organization tenant
// ====================================== GETTING STARTED ====================================== //
// successfull deployed parents
// ====================================== PARAMETERS =========================================== //
param location string = deployment().location
// ====================================== VARIABLES ============================================ //
var config = loadJsonContent('../../config.json')
var ORG_SUBSCRIPTION_ID = config.ORG_SUBSCRIPTION_ID
var orgName = config.ORG_NAME
var env = config.ORG_POSTFIX
var countryCode = config.ORG_COUNTRY_CODE
var tenantRegion = config.ORG_TENANT_REGION
var rootTenantName = createShortTenantName(orgName, env)
var fullRootTenantName = createFullTenantName(rootTenantName)
var rootRGName = createResourceGroupName(orgName, location, env)
// ====================================== MODULES ============================================== //
module rootTenant '../modules/tenant/tenant.bicep' = {
  name: 'rootTenantModule'
  scope: resourceGroup(ORG_SUBSCRIPTION_ID, rootRGName)
  params: {
    fullTenantName: fullRootTenantName
    countryCode: countryCode
    tenantRegion: tenantRegion
  }
}
// ====================================== OUTPUT =============================================== //
// TODO
// ====================================== EXECUTE ============================================== //
// az deployment tenant create --name orgTenantDeployment --location eastus --template-file "./.deploy/organization/2-org.bicep"
