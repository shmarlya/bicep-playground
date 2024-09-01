
targetScope = 'resourceGroup'

// ====================================== BRIEF DESCRIPTION ==================================== //
// ====================================== GETTING STARTED ====================================== //
// ====================================== PARAMETERS =========================================== //
// ====================================== PARAMETERS =========================================== //
// ====================================== VARIABLES ============================================ //
// ====================================== RESOURCES ============================================ //
// ====================================== VARIABLES ============================================ //
// ====================================== ROOT IAC ============================================= //
// ====================================== MODULES ============================================== //
// ====================================== OUTPUT =============================================== //
// ====================================== EXECUTE ============================================== //
@allowed(
  [
    'dev'
    'prod'
  ]
)
param env string
param WEB_APP_DOMAIN string
param PORT string
param SOCKET_PORT string
param STRIPE_SECRET string
param STRIPE_WEBHOOK_SECRET string
param FULL_TENANT_NAME string
param B2C_REDIRECT_URL string
param storageName string
param appServicePlanName string
param tenantName string
param congitiveServiceName string
param keyVaultName string
param certificateName string
param certificateSubject string
@secure()
param webIdentityPrincipalId string

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

module certModule '../scripts/cert/create-cert.bicep' = {
  name: 'certModule'
  params: {
    vaultName: keyVaultName
    certificateName: certificateName
    subjectName: certificateSubject
    webIdentityId: webIdentityPrincipalId
  }
}

module appsModule '../modules/apps/apps.bicep' = {
  name: 'appsModule'
  params: {
    B2C_REDIRECT_URL: B2C_REDIRECT_URL
    FULL_TENANT_NAME: FULL_TENANT_NAME
    WEB_APP_DOMAIN: WEB_APP_DOMAIN
    certKey: certModule.outputs.certKey
    certStartDate: certModule.outputs.certStartDate
    certEndDate: certModule.outputs.certEndDate
  }
}


module storageModule '../modules/storage/storage.bicep'= {
  name: 'storageModule' 
  params: {
    storageName: storageName
    storageSku: resourcesMap[env].storageSKU 
  }
}

module congitiveModule '../modules/cognitive/computer-vision.bicep' = {
  name: 'congitiveModule'
  params: {
    sku: resourcesMap[env].computeVisionSKU
    congitiveServiceName: congitiveServiceName
  }
}

module hostingModule '../modules/hosting/hosting.bicep'= {
  name: 'hostingModule'
  params: {
    hostingSKU: resourcesMap[env].hostingSKU
    appServicePlanName: appServicePlanName
    webAppName: tenantName
    ENV: env
    WEB_APP_DOMAIN: WEB_APP_DOMAIN
    PORT: PORT
    SOCKET_PORT: SOCKET_PORT
    STRIPE_SECRET: STRIPE_SECRET
    STRIPE_WEBHOOK_SECRET: STRIPE_WEBHOOK_SECRET
    AZURE_STORAGE_CONNECTION_STRING: storageModule.outputs.AZURE_STORAGE_CONNECTION_STRING
    AZURE_STORAGE_BLOB_DOMAIN: storageModule.outputs.AZURE_STORAGE_BLOB_DOMAIN
    AZURE_COMPUTER_VISION_KEY : congitiveModule.outputs.AZURE_COMPUTER_VISION_KEY
    AZURE_COMPUTER_VISION_ENDPOINT: congitiveModule.outputs.AZURE_COMPUTER_VISION_ENDPOINT
    B2C_REDIRECT_URL: B2C_REDIRECT_URL
  }
}





