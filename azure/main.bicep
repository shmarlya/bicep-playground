import {createStandardPrefix} from './modules/common.bicep'

targetScope = 'tenant'

@minLength(3)
@maxLength(12)
@description('Project name - best is to choose tenant name aka. domain name')
param projectName string

@description('Location for the deployments and the resources')
param location string = deployment().location

@allowed(
  [
    'production'
    'test'
  ]
)
param environment string

param billingAccountName string
param billingProfileName string
param invoiceSectionName string

var commonPrefix = createStandardPrefix(projectName, environment, location)
var managmentGroupName = '${commonPrefix}MG'
var subscriptionName = '${commonPrefix}SUB'

resource symbolicMGname 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: managmentGroupName
  properties: {
    displayName: managmentGroupName
  }
}

resource subscription 'Microsoft.Subscription/aliases@2021-10-01' = {
  name: subscriptionName
  properties: {
    additionalProperties: {
      managementGroupId: symbolicMGname.id
      tags: {}
    }
    billingScope: '/billingAccounts/${billingAccountName}/billingProfiles/${billingProfileName}/invoiceSections/${invoiceSectionName}'
    displayName: subscriptionName
    // cant upload DevTest workload type
    // doesnt work for some reason and give 400 error
    workload: 'Production'
  }
}
