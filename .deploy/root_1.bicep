
import {createManagmentGroupName, createSubscriptionName} from './modules/funcs.bicep'

targetScope = 'tenant'

// az login --tenant xxxxxx
// az deployment tenant create --name root1Deployment --location eastus --template-file "./.deploy/root_1.bicep" --parameters "./.deploy/root_1.bicepparam"

// ====================================== PARAMETERS =========================================== //
param orgName string
param billingProfileName string
param invoiceSectionName string
param billingAccountName string
// ====================================== VARIABLES =========================================== //

var rootManagmentGroupName = createManagmentGroupName(orgName)
var placeholderSubscriptionName = createSubscriptionName(orgName, 'root')

// ====================================== ROOT IAC =========================================== //
module managmentGroupModule './modules/mg/mgmnt-group.bicep' = {
  name: 'rootManagmentGroupModule'
  params:{
    managmentGroupName: rootManagmentGroupName
  }
}

module placeholderSubscription './modules/sub/subscription.create.bicep' = {
  name: 'rootSubscriptionModule'
  params: {
    subscriptionName: placeholderSubscriptionName
    managementGroupId: managmentGroupModule.outputs.managementGroupId
    billingProfileName: billingProfileName
    invoiceSectionName: invoiceSectionName
    billingAccountName: billingAccountName
  }
}


