using 'main.bicep'

// for pipe line it should be set to false
param firstTimeDeploy = true
param orgSubscriptionId = ''
param projectName = 'bibas'

//tenant module
param tenantRegion = 'United States'
param countryCode = 'US'

// web api params
param PORT = '3000'
param SOCKET_PORT = '3333'
param STRIPE_SECRET = 'STRIPE_SECRET'
param STRIPE_WEBHOOK_SECRET = 'STRIPE_WEBHOOK_SECRET'

param billingAccountName = ''
param billingProfileName = ''
param invoiceSectionName = ''
param subscriptionTenantId = ''
