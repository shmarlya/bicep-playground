import {createResourceGroupName, createKVName, createManagedIdentityName} from '../../functions/resource-names.bicep'

var config = loadJsonContent('../../config.json')
var project = config.PROEJCTS[0]
var projectName = project.PROJECT_NAME
var location = resourceGroup().location

module projectEnvRGModule '../../modules/rg/resource-group.bicep' = [for (env, i) in project.ENVIRONMENTS: {
  name: 'projectSubscription-${projectName}-${env}'
  scope: subscription(env.subsciprtionId)
  params: {
    location: location
    resourceGroupName: createResourceGroupName(projectName, location, env.envName)
  }
}]

module webIdentityModule '../../modules/managedIdentity/userAssigned.bicep' = [for (env, i) in project.ENVIRONMENTS: {
  name: 'webIdentityModule'
  dependsOn: [projectEnvRGModule]
  scope: resourceGroup(createResourceGroupName(projectName, location, env.envName))
  params: {
    identityName: createManagedIdentityName(projectName, env.envName)
  }
}]

module kvModule '../../modules/kv/kv.bicep' = [for (env, i) in project.ENVIRONMENTS: {
  name: 'kvModule'
  dependsOn: [projectEnvRGModule]
  scope: resourceGroup(createResourceGroupName(projectName, location, env.envName))
  params: {
    keyVaultName: createKVName(projectName, env.envName)
    webIdentityPrincipalId: webIdentityModule[i].outputs.managedIdentityPrincipalId
    tenantId: env.tenantId
  }
}]
