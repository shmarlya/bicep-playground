
import {createManagmentGroupName, createSubscriptionName, createBudgetName, createCongitiveServiceName} from './modules/funcs.bicep'
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

param PORT string
param SOCKET_PORT string
param STRIPE_SECRET string
param STRIPE_WEBHOOK_SECRET string

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
    PORT: PORT
    SOCKET_PORT: SOCKET_PORT
    STRIPE_SECRET: STRIPE_SECRET
    STRIPE_WEBHOOK_SECRET: STRIPE_WEBHOOK_SECRET
    
  }
}]


