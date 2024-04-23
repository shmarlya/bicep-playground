
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
  'NODE:20-lts'
])
param linuxFxVersion string = 'NODE:20-lts'
param webAppName string
param AZURE_STORAGE_CONNECTION_STRING string

resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      appSettings: [
        {
          name: 'AZURE_STORAGE_CONNECTION_STRING'
          value:  AZURE_STORAGE_CONNECTION_STRING
        }
      ]
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}
