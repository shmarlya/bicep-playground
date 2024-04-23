
targetScope = 'tenant'

param subscriptionId string
param budgetName string
param contactEmails array
param budgetStartDate string
param budgetEndDate string


module budgetModule './budget.bicep' = {
  name: 'budgetModule'
  scope: subscription(subscriptionId)
  params: {
    budgetName: budgetName
    contactEmails: contactEmails
    startDate: budgetStartDate
    endDate: budgetEndDate
  }
}
