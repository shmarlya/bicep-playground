using 'main.bicep'

// for pipe line it should be set to false
// because sp cant create subscriptions with default permissions
// so you have to run deploy locally once - under your user 
// (and dont forget to set it to true in that case)
param firstTimeDeploy = false

// managment group module
param orgName = ''


// subscription module
param projectName = ''
param location = ''

param billingAccountName = ''
param billingProfileName = ''
param invoiceSectionName = ''


// budget module
param contactEmails = ['yarmovan@gmail.com']
param budgetStartDate = '2024-06-01'
param budgetEndDate = '2025-06-30'


//tenant module
param tenantRegion = 'europe'
param countryCode = 'PL'
