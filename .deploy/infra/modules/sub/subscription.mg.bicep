

targetScope = 'tenant'

// ====================================== PARAMETERS =========================================== //
param managementGroupId string
param subscriptionName string
@description('Payment account necessary info - az billing account list')
param billingProfileName string
@description('Payment account necessary info - az billing account list-invoice-section --billing-account-name')
param invoiceSectionName string
@description('Payment account necessary info - az billing account list-invoice-section --billing-account-name')
param billingAccountName string

// ====================================== RESOURCES ============================================ //
resource subscriptionAlias 'Microsoft.Subscription/aliases@2021-10-01' = {
  name: subscriptionName
  properties: {
    additionalProperties: {
      managementGroupId: managementGroupId
      tags: {}
    }
    billingScope: '/billingAccounts/${billingAccountName}/billingProfiles/${billingProfileName}/invoiceSections/${invoiceSectionName}'
    displayName: subscriptionName
    // cant upload DevTest workload type
    // doesnt work for some reason and give 400 error
    workload: 'Production'
  }
}
// ====================================== OUTPUT =============================================== //
output subscriptionId string = subscriptionAlias.properties.subscriptionId
