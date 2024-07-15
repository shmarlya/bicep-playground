

param congitiveServiceName string

@description('Location for all resources.')
// AVAILABLE ONLY IN SOME REGIONS
// https://azure.microsoft.com/en-us/explore/global-infrastructure/products-by-region/?products=cognitive-services&regions=all#products-by-region_tab0
param location string = 'eastus'

@allowed([
  'F0'
  'S1'
])
// allowed only 1 free service per account
param sku string = 'F0'

resource cognitiveService 'Microsoft.CognitiveServices/accounts@2021-10-01' = {
  name: congitiveServiceName
  location: location
  sku: {
    name: sku
  }
  kind: 'ComputerVision'
  properties: {
    apiProperties: {
      statisticsEnabled: false
    }
  }
}

output AZURE_COMPUTER_VISION_KEY string = cognitiveService.listKeys().key1
output AZURE_COMPUTER_VISION_ENDPOINT string = cognitiveService.properties.endpoint


