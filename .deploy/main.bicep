
import {createManagmentGroupName, createSubscriptionName, createBudgetName} from './modules/funcs.bicep'
var config = loadJsonContent('./config.json')

targetScope = 'tenant'

param firstTimeDeploy bool

param orgName string

module managmentGroupModule './modules/mg/mgmnt-group.bicep' = {
  name: 'managmentGroupModule'
  params:{
    orgName:orgName
  }
}

param projectName string
param location string
param billingProfileName string
param invoiceSectionName string
param billingAccountName string

var subscriptionName = createSubscriptionName(projectName, location)

module subscriptionModule './modules/sub/subscription.create.bicep' = {
  name: 'subscriptionModule'
  params: {
    managementGroupId: managmentGroupModule.outputs.managementGroupId
    subscriptionName: subscriptionName
    billingProfileName: billingProfileName
    invoiceSectionName: invoiceSectionName
    billingAccountName: billingAccountName
  }
}


param contactEmails array
param budgetStartDate string
param budgetEndDate string
var budgetName = createBudgetName(projectName)

module budgetWrapperModule './modules/budget/budget-wrapper.bicep' = {
  name: 'budgetModuleWrapper'
  params: {
    subscriptionId: subscriptionModule.outputs.subscriptionId
    budgetName: budgetName
    contactEmails: contactEmails
    budgetStartDate: budgetStartDate
    budgetEndDate: budgetEndDate
  }
}


param countryCode string
param tenantRegion string
module resourcesWrapper './modules/resources-wrapper.bicep' = [for (env, i) in config.ENVIRONMENTS: {
  name: 'resources-wrapper-${env}'
  params: {
    firstTimeDeploy: firstTimeDeploy
    env:env
    subscriptionId: subscriptionModule.outputs.subscriptionId
    location: location
    projectName: projectName
    countryCode: countryCode
    tenantRegion: tenantRegion
  }
}]


