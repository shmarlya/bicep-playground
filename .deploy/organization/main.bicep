import {createBudgetName, createResourceGroupName, createCongitiveServiceName, createManagmentGroupName} from '../infra/functions/resource-names.bicep'

targetScope = 'subscription'
// ====================================== BRIEF DESCRIPTION ==================================== //
// creating budget limit for org subscription
// ====================================== GETTING STARTED ====================================== //
// successfull deployed parents
// az account set --subscription xxxxxxxxxxxxxxx
// az account show 
// ====================================== PARAMETERS =========================================== //
// ====================================== VARIABLES ============================================ //
var config = loadJsonContent('../config.json')
var orgName = config.ORG_NAME
var contactEmails = config.ORG_DATA.contactEmails
var budgetStartDate = config.ORG_DATA.budgetStartDate
var budgetEndDate = config.ORG_DATA.budgetEndDate
var organizationSubscriptionId = config.ORG_SUBSCRIPTION_ID
var budgetName = createBudgetName(orgName)
var managmentGroupName = createManagmentGroupName(orgName)
// ====================================== RESOURCES ============================================ //
// ====================================== MODULES ============================================== //
module organizationMGModule '../infra/modules/mg/mg.bicep' = {
  name: 'organizationMGModule'
  scope: tenant()
  params: {
    managmentGroupName: managmentGroupName
  }
}

module organizationSubBudgetModule '../infra/modules/budget/budget-wrapper.bicep' = {
  name: 'organizationSubBudgetModule'
  scope: tenant()
  params: {
    subscriptionId: organizationSubscriptionId
    budgetName: budgetName
    contactEmails: contactEmails
    budgetStartDate: budgetStartDate
    budgetEndDate: budgetEndDate
  }
}

// ====================================== OUTPUT =============================================== //
// ====================================== EXECUTE ============================================== //
// az deployment sub create --name orgRGDeployment --location eastus --template-file "./.deploy/organization/4-org.bicep"
