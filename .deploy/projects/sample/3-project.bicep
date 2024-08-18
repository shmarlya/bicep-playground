import {createSubscriptionName} from '../../functions/resource-names.bicep'
targetScope = 'tenant'
// ====================================== BRIEF DESCRIPTION ==================================== //
// creating project env subscription in 
// ====================================== GETTING STARTED ====================================== //
// successfull deployed parents
// az account set --subscription xxxxxxxxxxxxxxx
// ====================================== PARAMETERS =========================================== //
// ====================================== VARIABLES ============================================ //
var config = loadJsonContent('../../config.json')
var billingProfileName = config.USER_BILINGINFO.billingProfileName
var invoiceSectionName = config.USER_BILINGINFO.invoiceSectionName
var billingAccountName = config.USER_BILINGINFO.billingAccountName
// ====================================== MODULES ============================================== //
module projectSubscription '../../modules/sub/subscription.tenant.bicep' = [for (env, i) in config.ENVIRONMENTS: {
  name: 'projectSubscription-${config.PROJECT_NAME}-${env}'
  params: {
    subscriptionName: createSubscriptionName(config.PROJECT_NAME, env)
    subscriptionTenantId: config.PROJECT[env].tenantId
    billingProfileName: billingProfileName
    invoiceSectionName: invoiceSectionName
    billingAccountName: billingAccountName
  }
}]
// ====================================== OUTPUT =============================================== //
// ====================================== EXECUTE ============================================== //
// az deployment tenant create --name projectSubEnvDeployment --location eastus --template-file "./.deploy/projects/sample/3-project.bicep"
