
@allowed([
  'F1'
])
param hostingSKU string
param appServicePlanName string
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: resourceGroup().location
  kind: 'linux'
  sku: {
    name: hostingSKU
  }
  properties: {
    reserved: true
  }
}


@allowed([
  'Node|20'
])
param linuxFxVersion string = 'Node|20'
param webAppName string
param ENV string
param AZURE_COMPUTER_VISION_KEY string
param AZURE_COMPUTER_VISION_ENDPOINT string
param AZURE_STORAGE_CONNECTION_STRING string
param AZURE_STORAGE_BLOB_DOMAIN string
param WEB_APP_DOMAIN string
param PORT string
param SOCKET_PORT string
param STRIPE_SECRET string
param STRIPE_WEBHOOK_SECRET string
param B2C_REDIRECT_URL string

resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      appSettings: [
        {
          name: 'ENV'
          value:  ENV
        }
        {
          name: 'WEB_APP_DOMAIN'
          value: WEB_APP_DOMAIN
        }
        {
          name: 'PORT'
          value: PORT
        }
        {
          name: 'SOCKET_PORT'
          value:  SOCKET_PORT
        }
        {
          name: 'STRIPE_SECRET'
          value:  STRIPE_SECRET
        }
        {
          name: 'STRIPE_WEBHOOK_SECRET'
          value:  STRIPE_WEBHOOK_SECRET
        }
        {
          name: 'AZURE_STORAGE_CONNECTION_STRING'
          value:  AZURE_STORAGE_CONNECTION_STRING
        }
        {
          name:'AZURE_STORAGE_BLOB_DOMAIN'
          value:AZURE_STORAGE_BLOB_DOMAIN
        }
        {
          name: 'AZURE_COMPUTER_VISION_KEY'
          value: AZURE_COMPUTER_VISION_KEY
        }
        {
          name: 'AZURE_COMPUTER_VISION_ENDPOINT'
          value: AZURE_COMPUTER_VISION_ENDPOINT
        }
        {
          name:'B2C_REDIRECT_URL'
          value: B2C_REDIRECT_URL
        }
      ]
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}
