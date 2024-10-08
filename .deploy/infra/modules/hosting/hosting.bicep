
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
  'NODE|20-lts'
])
param linuxFxVersion string = 'NODE|20-lts'
param appCommandLine string
param webAppName string


@secure()
param ENV string
@secure()
param AZURE_COMPUTER_VISION_KEY string
@secure()
param AZURE_COMPUTER_VISION_ENDPOINT string
@secure()
param AZURE_STORAGE_CONNECTION_STRING string
@secure()
param AZURE_STORAGE_BLOB_DOMAIN string
@secure()
param WEB_APP_DOMAIN string
@secure()
param PORT string
@secure()
param SOCKET_PORT string
@secure()
param STRIPE_SECRET string
@secure()
param STRIPE_WEBHOOK_SECRET string
@secure()
param B2C_REDIRECT_URL string
@secure()
param B2C_CLIENT_APPLICATION_ID string
@secure()
param B2C_SERVER_APPLICATION_ID string
@secure()
param B2C_SERVER_APPLICATION_SECRET string

param FULL_GITHUB_PROJECT_REPOSITORY string
param PROJECT_ENV_BRANCH_NAME string


resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      netFrameworkVersion: null
      phpVersion: null
      windowsFxVersion: null
      nodeVersion: null
      linuxFxVersion: linuxFxVersion
      appCommandLine: appCommandLine
      appSettings: [
        {
          name: 'ENV'
          value: ENV
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
        {
          name:'B2C_CLIENT_APPLICATION_ID'
          value: B2C_CLIENT_APPLICATION_ID
        }
        {
          name:'B2C_SERVER_APPLICATION_ID'
          value: B2C_SERVER_APPLICATION_ID
        }
        {
          name:'B2C_SERVER_APPLICATION_SECRET'
          value: B2C_SERVER_APPLICATION_SECRET
        }
      ]
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-01-01' = {
  name: 'web'
  parent: appService
  properties: {
    repoUrl: FULL_GITHUB_PROJECT_REPOSITORY
    branch: PROJECT_ENV_BRANCH_NAME
    isManualIntegration: true
  }
}
