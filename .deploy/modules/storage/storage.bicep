
import {createStorageConnectionString} from '../funcs.bicep'

@minLength(3)
@maxLength(24)
param storageName string

@allowed([
  'Standard_LRS'
])
param storageSku string

resource storage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageName
  location: resourceGroup().location
  sku: {
    name: storageSku
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    // for test purposes
    allowBlobPublicAccess: true
  }
}

var connectStr = createStorageConnectionString(storageName, storage.listKeys().keys[0].value)

output AZURE_STORAGE_CONNECTION_STRING string = connectStr

