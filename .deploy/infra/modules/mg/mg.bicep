
targetScope = 'tenant'

param managmentGroupName string

resource managmentGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: managmentGroupName
  properties: {
    displayName: managmentGroupName
  }
}

output managementGroupId string = managmentGroup.id
