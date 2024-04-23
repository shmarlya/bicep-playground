import {createManagmentGroupName} from '../funcs.bicep'

targetScope = 'tenant'

@description('Organization name')
param orgName string

var managmentGroupName = createManagmentGroupName(orgName)

resource managmentGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: managmentGroupName
  properties: {
    displayName: managmentGroupName
  }
}

output managementGroupId string = managmentGroup.id
