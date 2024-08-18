import {createB2CapplicationRedirectUri} from '../../functions/resource-names.bicep'

provider microsoftGraph


// ====================================== BRIEF DESCRIPTION ==================================== //
// ====================================== GETTING STARTED ====================================== //
// ====================================== PARAMETERS =========================================== //
param B2C_REDIRECT_URL string
param tenantName string
// ====================================== VARIABLES ============================================ //
var wellKnown = {
  MSGRAPH_APP_ID: '00000003-0000-0000-c000-000000000000'
  MSGRAPH_APP_WEBAPI_PERMISSIONS: {
    openid: '311a71cc-e848-46a1-bdf8-97ff7156d8e6'
    offline_access: '7427af44-ae7c-4d5f-8a9a-a1bd3c0ebf4e'
    'User.ReadWrite.All': '741f803b-c850-494e-b5df-cde7c675a1ca'
    'User.ManageIdentities.All': 'c529cfca-c91b-489c-af2b-d92990b66ce6'
    'Group.ReadWrite.All': '62a82d76-70ea-41e2-9197-370581804d09'
    'Policy.ReadWrite.TrustFramework': '79a677f7-b79d-40d0-a36a-3e6f8688dd7a'
  }
}

var IdentityExperienceFramework_NAME = 'IdentityExperienceFramework'
var IdentityExperienceFramework_SCOPE = 'user_impersonation'
var IdentityExperienceFramework_REDIRECT_URI = createB2CapplicationRedirectUri(tenantName)
// ====================================== RESOURCES ============================================ //
resource MSGRAPH_SP 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: wellKnown.MSGRAPH_APP_ID
}

resource IdentityExperienceFramework_APP 'Microsoft.Graph/applications@v1.0' = {
  uniqueName: IdentityExperienceFramework_NAME
  displayName: IdentityExperienceFramework_NAME
  signInAudience: 'AzureADMyOrg'
  web: {
    redirectUris: [B2C_REDIRECT_URL]
  }
  requiredResourceAccess: [
    {
      resourceAppId: wellKnown.MSGRAPH_APP_ID
      resourceAccess: [
        {
          id: wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS.openid // openid
          type: 'Scope'
        }
        {
          id: wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS.offline_access // offline_access
          type: 'Scope'
        }
      ]
    }
  ]
}

resource IdentityExperienceFramework_SP 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: IdentityExperienceFramework_APP.appId
}

resource identityExperienceFrameworkApiScope 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = {
    consentType: 'AllPrincipals'
    clientId: IdentityExperienceFramework_SP.id
    scope: IdentityExperienceFramework_SCOPE
    resourceId: MSGRAPH_SP.id
}

// resource IdentityExperienceFramework_PERMISSION_GRANT_MSGRAPH 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = {
//   clientId: IdentityExperienceFramework_SP.id
//   consentType: 'AllPrincipals'
//   resourceId: MSGRAPH_SP.id
//   scope: wellKnown.MSGRAPH_DEFAULT_SCOPE
// }



// var ProxyIdentityExperienceFramework_NAME = 'ProxyIdentityExperienceFramework'
// resource ProxyIdentityExperienceFramework_APP 'Microsoft.Graph/applications@v1.0' = {
//   uniqueName: ProxyIdentityExperienceFramework_NAME
//   displayName: ProxyIdentityExperienceFramework_NAME
//   signInAudience: 'AzureADMyOrg'
//   publicClient: {
//     redirectUris: ['myapp://auth']
//   }
// }

// resource ProxyIdentityExperienceFramework_SP 'Microsoft.Graph/servicePrincipals@v1.0' = {
//   appId: ProxyIdentityExperienceFramework_APP.appId
// }

// resource ProxyIdentityExperienceFramework_PERMISSION_GRANT_MSGRAPH 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = {
//   clientId: ProxyIdentityExperienceFramework_SP.id
//   consentType: 'AllPrincipals'
//   resourceId: MSGRAPH_SP.id
//   scope: wellKnown.MSGRAPH_DEFAULT_SCOPE
// }

// resource ProxyIdentityExperienceFramework_PERMISSION_GRANT_IDENTITY 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = {
//   clientId: ProxyIdentityExperienceFramework_SP.id
//   consentType: 'AllPrincipals'
//   resourceId: IdentityExperienceFramework_SP.id
//   scope: IdentityExperienceFramework_SCOPE
// }


// var WebApi_NAME = 'web-api'
// var WebApi_EXPOSED_SCOPE_NAME = 'STANDARD.USER.API'
// resource WebApi_APP 'Microsoft.Graph/applications@v1.0' = {
//   uniqueName: WebApi_NAME
//   displayName: WebApi_NAME
//   signInAudience: 'AzureADandPersonalMicrosoftAccount'
//   passwordCredentials: [{
//     displayName: 'test-secret'
//   }]
//   api: {
//     oauth2PermissionScopes: [
//       {
//         adminConsentDescription: 'Allows SPA use the web api'
//         adminConsentDisplayName: 'Allows SPA use the web api'
//         isEnabled: true
//         value: WebApi_EXPOSED_SCOPE_NAME
//         type: 'Admin'
//       }
//     ]
//   }
//   web: {
//     implicitGrantSettings: {
//       enableAccessTokenIssuance:false
//       enableIdTokenIssuance: false
//     }
//   }
//   isFallbackPublicClient: false
// }

// resource WebApi_SP 'Microsoft.Graph/servicePrincipals@v1.0' = {
//   appId: WebApi_APP.appId
// }

// resource WebApi_appRoleAssignment_1 'Microsoft.Graph/appRoleAssignedTo@v1.0' = {
//   principalId: WebApi_SP.id
//   resourceId: MSGRAPH_SP.id
//   appRoleId: wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS['User.ReadWrite.All']
// }
// resource WebApi_appRoleAssignment_2 'Microsoft.Graph/appRoleAssignedTo@v1.0' = {
//   principalId: WebApi_SP.id
//   resourceId: MSGRAPH_SP.id
//   appRoleId: wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS['Group.ReadWrite.All']
// }
// resource WebApi_appRoleAssignment_3 'Microsoft.Graph/appRoleAssignedTo@v1.0' = {
//   principalId: WebApi_SP.id
//   resourceId: MSGRAPH_SP.id
//   appRoleId: wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS['User.ManageIdentities.All']
// }
// resource WebApi_appRoleAssignment_4 'Microsoft.Graph/appRoleAssignedTo@v1.0' = {
//   principalId: WebApi_SP.id
//   resourceId: MSGRAPH_SP.id
//   appRoleId: wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS['Policy.ReadWrite.TrustFramework']
// }


// var WebSPA_NAME = 'web-spa'
// resource WebSPA_NAME_APP 'Microsoft.Graph/applications@v1.0' = {
//   uniqueName: WebSPA_NAME
//   displayName: WebSPA_NAME
//   signInAudience: 'AzureADandPersonalMicrosoftAccount'
//   spa: {
//     // TODO: remove all except domain
//     // for test purposes 
//     redirectUris: ['http://localhost:3000', 'https://jwt.ms', DOMAIN_NAME]
//   }
//   web: {
//     implicitGrantSettings: {
//       enableAccessTokenIssuance:false
//       enableIdTokenIssuance: false
//     }
//   }
//   isFallbackPublicClient: true
// }
