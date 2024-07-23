import {createShortTenantName, createBudgetName, createResourceGroupName, createFullTenantName} from 'modules/funcs.bicep'

targetScope = 'tenant'
// az account set --subscription xxxxxxxxxxxxxxx
// az deployment tenant create --name root2Deployment --location eastus --template-file "./.deploy/root_2.bicep" --parameters "./.deploy/root_2.bicepparam"

// ====================================== PARAMETERS =========================================== //
param orgName string
param projectName string
param location string = deployment().location
param subscriptionId string
@allowed(
  [
    'PL'
    'US'
  ]
)
param countryCode string
@allowed([
  'United States'
  'Europe'
])
param tenantRegion string
param contactEmails array
param budgetStartDate string
param budgetEndDate string
// ====================================== VARIABLES =========================================== //
var rootRGName = createResourceGroupName(projectName, orgName, 'root')
var rootTenantName = createShortTenantName(projectName, 'root')
var fullRootTenantName = createFullTenantName(rootTenantName)
var budgetName = createBudgetName(orgName)
// ====================================== ROOT IAC =========================================== //
module rootRG './modules/rg/rsrc-group.bicep' =  {
  name: 'rootRGmodule'
  scope: subscription(subscriptionId)
  params: {
    location: location
    resourceGroupName: rootRGName
  }
}

module rootTenant './modules/tenant/tenant.bicep' = {
  name: 'rootTenantModule'
  dependsOn: [rootRG]
  scope: resourceGroup(subscriptionId, rootRGName)
  params: {
    fullTenantName: fullRootTenantName
    countryCode: countryCode
    tenantRegion: tenantRegion
  }
}

module rootBudgetWrapperModule './modules/budget/budget-wrapper.bicep' = {
  name: 'rootBudgetWrapperModule'
  params: {
    subscriptionId: subscriptionId
    budgetName: budgetName
    contactEmails: contactEmails
    budgetStartDate: budgetStartDate
    budgetEndDate: budgetEndDate
  }
}
