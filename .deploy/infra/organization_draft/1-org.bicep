
import {createResourceGroupName} from '../functions/resource-names.bicep'

targetScope = 'tenant'
// ====================================== BRIEF DESCRIPTION ==================================== //
// create root org resource group
// ====================================== GETTING STARTED ====================================== //
// az login
// az account show 
// az account set --subscription xxxxxxxxxxxxxxx

// ====================================== PARAMETERS =========================================== //
param location string = deployment().location

// ====================================== VARIABLES ============================================ //
var config = loadJsonContent('../../config.json')
var ORG_SUBSCRIPTION_ID = config.ORG_SUBSCRIPTION_ID
var env = config.ORG_POSTFIX
var orgName = config.ORG_NAME
var rootRGName = createResourceGroupName(orgName, location, env)
// ====================================== MODULES ============================================== //
module rootRG '../modules/rg/resource-group.bicep' =  {
  name: 'rootRGmodule'
  scope: subscription(ORG_SUBSCRIPTION_ID)
  params: {
    location: location
    resourceGroupName: rootRGName
  }
}

// ====================================== OUTPUT =============================================== //
output rootRGName string = rootRGName
// ====================================== EXECUTE ============================================== //
// az deployment tenant create --name orgRgDeployment --location eastus --template-file "./.deploy/organization/1-org.bicep"
