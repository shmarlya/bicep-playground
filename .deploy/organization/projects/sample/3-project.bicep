import {createSubscriptionName} from '../../../infra/functions/resource-names.bicep'
targetScope = 'tenant'
// ====================================== BRIEF DESCRIPTION ==================================== //
// creating project env subscription in 
// ====================================== GETTING STARTED ====================================== //
// successfull deployed parents
// az account set --subscription xxxxxxxxxxxxxxx
// ====================================== PARAMETERS =========================================== //
// ====================================== VARIABLES ============================================ //
var config = loadJsonContent('../../../config.json')
var secrets = loadJsonContent('../../../secrets.json')
var project = config.PROJECTS[0]
var projectName = project.PROJECT_NAME
var billingProfileName = secrets.AZURE_USER_BILINGINFO.billingProfileName
var invoiceSectionName = secrets.AZURE_USER_BILINGINFO.invoiceSectionName
var billingAccountName = secrets.AZURE_USER_BILINGINFO.billingAccountName
// ====================================== MODULES ============================================== //
module projectSubscription '../../../infra/modules/sub/subscription.tenant.bicep' = [for (env, i) in project.ENVIRONMENTS: {
  name: 'projectSubscription-${projectName}-${env}'
  params: {
    subscriptionName: createSubscriptionName(projectName, env.PROJECT_ENV_NAME)
    subscriptionTenantId: env.PROJECT_ENV_TENANT_ID
    billingProfileName: billingProfileName
    invoiceSectionName: invoiceSectionName
    billingAccountName: billingAccountName
  }
}]
// ====================================== OUTPUT =============================================== //
// ====================================== EXECUTE ============================================== //
// az deployment tenant create --name projectSubEnvDeployment --location eastus --template-file "./.deploy/projects/sample/3-project.bicep"
