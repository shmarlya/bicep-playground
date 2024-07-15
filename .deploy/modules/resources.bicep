
targetScope = 'resourceGroup'

@allowed([
  'prod'
  'dev'
])
param env string
param DOMAIN_NAME string
param PORT string
param SOCKET_PORT string
param STRIPE_SECRET string
param STRIPE_WEBHOOK_SECRET string

var resourcesMap = {
  prod: {
    storageSKU: 'Standard_LRS'
    hostingSKU: 'F1'
    computeVisionSKU: 'S1'
  }
  dev: {
    storageSKU: 'Standard_LRS'
    hostingSKU: 'F1'
    // computeVisionSKU: 'F0'
    computeVisionSKU: 'S1'
  }
}

@minLength(3)
param storageName string
module storageModule './storage/storage.bicep'= {
  name: 'storageModule' 
  params: {
    storageName: storageName
    storageSku: resourcesMap[env].storageSKU 
  }
}

param congitiveServiceName string
module congitiveModule './cognitive/computer-vision.bicep' = {
  name: 'congitiveModule'
  params: {
    sku: resourcesMap[env].computeVisionSKU 
    congitiveServiceName: congitiveServiceName
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
    ENV: env
    DOMAIN_NAME: DOMAIN_NAME
    PORT: PORT
    SOCKET_PORT: SOCKET_PORT
    STRIPE_SECRET: STRIPE_SECRET
    STRIPE_WEBHOOK_SECRET: STRIPE_WEBHOOK_SECRET
    AZURE_STORAGE_CONNECTION_STRING: storageModule.outputs.AZURE_STORAGE_CONNECTION_STRING
    AZURE_STORAGE_BLOB_DOMAIN: storageModule.outputs.AZURE_STORAGE_BLOB_DOMAIN
    AZURE_COMPUTER_VISION_KEY : congitiveModule.outputs.AZURE_COMPUTER_VISION_KEY
    AZURE_COMPUTER_VISION_ENDPOINT: congitiveModule.outputs.AZURE_COMPUTER_VISION_ENDPOINT
  }
}





