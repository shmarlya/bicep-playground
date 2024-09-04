import {createSubscriptionName, createShortTenantName, createResourceGroupName, createFullTenantName} from '../functions/resource-names.bicep'
targetScope = 'tenant'
// ====================================== BRIEF DESCRIPTION ==================================== //
// creating root orginzation subscription
// ====================================== GETTING STARTED ====================================== //
// successfull deployed parents
// ====================================== PARAMETERS =========================================== //
param location string = deployment().location
// ====================================== VARIABLES ============================================ //
var config = loadJsonContent('../../config.json')
var secrets = loadJsonContent('../../secrets.json')
var orgName = config.ORG_NAME
var env = config.ORG_POSTFIX
var userSubscriptionId = config.ORG_SUBSCRIPTION_ID
var rootOrgSubscriptionName = createSubscriptionName(orgName, env)
var billingProfileName = secrets.AZURE_USER_BILINGINFO.billingProfileName
var invoiceSectionName = secrets.AZURE_USER_BILINGINFO.invoiceSectionName
var billingAccountName = secrets.AZURE_USER_BILINGINFO.billingAccountName
var rootRGName = createResourceGroupName(orgName, location, env)
var fullRootTenantName = createFullTenantName(createShortTenantName(orgName, env))
// ====================================== RESOURCES ============================================ //
resource tenant 'Microsoft.AzureActiveDirectory/b2cDirectories@2021-04-01' existing = {
  name: fullRootTenantName
  scope: resourceGroup(userSubscriptionId, rootRGName)
}
// ====================================== MODULES ============================================== //
module rootOrgSubscription '../modules/sub/subscription.tenant.bicep' = {
  name: 'rootOrgSubscription'
  params: {
    subscriptionName: rootOrgSubscriptionName
    subscriptionTenantId: tenant.properties.tenantId
    billingProfileName: billingProfileName
    invoiceSectionName: invoiceSectionName
    billingAccountName: billingAccountName
  }
}
// ====================================== OUTPUT =============================================== //
// TODO
// ====================================== EXECUTE ============================================== //
// az deployment tenant create --name orgSubDeployment --location eastus --template-file "./.deploy/organization/3-org.bicep" 
