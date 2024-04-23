
targetScope = 'resourceGroup'


@allowed([
  'prod'
  'dev'
])
param env string

var resourcesMap = {
  prod: {
    storageSKU: 'Standard_LRS'
    hostingSKU: 'F1'
  }
  dev: {
    storageSKU: 'Standard_LRS'
    hostingSKU: 'F1'
  }
}

@minLength(3)
@maxLength(10)
param storageName string
var uniqStorageName = '${storageName}${uniqueString(resourceGroup().id)}'
module storageModule './storage/storage.bicep'= {
  name: 'storageModule' 
  params: {
    storageName: uniqStorageName
    storageSku: resourcesMap[env].storageSKU 
  }
}


param appServicePlanName string
param webAppName string
module hostingModule './hosting/hosting.bicep'= {
  name: 'hostingModule'
  params: {
    hostingSKU: resourcesMap[env].hostingSKU
    appServicePlanName: appServicePlanName
    webAppName: webAppName
    AZURE_STORAGE_CONNECTION_STRING: storageModule.outputs.AZURE_STORAGE_CONNECTION_STRING
  }
}





