

targetScope = 'tenant'

param subscriptionTenantId string
param subscriptionName string

@description('Payment account necessary info - az billing account list')
param billingProfileName string
@description('Payment account necessary info - az billing account list-invoice-section --billing-account-name')
param invoiceSectionName string
@description('Payment account necessary info - az billing account list-invoice-section --billing-account-name')
param billingAccountName string

resource subscriptionAlias 'Microsoft.Subscription/aliases@2021-10-01' = {
  name: subscriptionName
  scope: tenant()
  properties: {
    additionalProperties: {
      subscriptionTenantId: subscriptionTenantId
      tags: {}
    }
    billingScope: '/billingAccounts/${billingAccountName}/billingProfiles/${billingProfileName}/invoiceSections/${invoiceSectionName}'
    displayName: subscriptionName
    // cant upload DevTest workload type
    // doesnt work for some reason and give 400 error
    workload: 'Production'
  }
}

output subscriptionId string = subscriptionAlias.properties.subscriptionId
