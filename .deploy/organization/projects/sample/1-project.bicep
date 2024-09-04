import {createResourceGroupName} from '../../../infra/functions/resource-names.bicep'
targetScope = 'subscription'

// ====================================== BRIEF DESCRIPTION ==================================== //
// creating resource groups and tenants for each environment of project from config.json
// ====================================== GETTING STARTED ====================================== //
// all organization templates are successfully deployed
// set subscrion to root organization subscirption id
// az account set --subscription xxxxxxxxxxxxxxx
// ====================================== PARAMETERS =========================================== //
param location string = deployment().location
// ====================================== VARIABLES ============================================ //
var config = loadJsonContent('../../../config.json')
var project = config.PROJECTS[0]
var projectName = project.PROJECT_NAME
// ====================================== MODULES ============================================== //
module resourceGroup '../../../infra/modules/rg/resource-group.bicep' = [for (env, i) in project.ENVIRONMENTS: {
  name: 'resourceGroup-${projectName}-${env}'
  params: {
    resourceGroupName: createResourceGroupName(projectName, location, env.PROJECT_ENV_NAME)
    location: location
  }
}]
// ====================================== OUTPUT =============================================== //
// ====================================== EXECUTE ============================================== //
// az deployment sub create --name projectEnvRGdeployment --location eastus --template-file "./.deploy/projects/sample/1-project.bicep"
