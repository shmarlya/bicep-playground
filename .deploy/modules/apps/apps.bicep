import {createB2CapplicationRedirectUri} from '../../functions/resource-names.bicep'

provider microsoftGraph

// ====================================== BRIEF DESCRIPTION ==================================== //
// ====================================== GETTING STARTED ====================================== //
// ====================================== PARAMETERS =========================================== //
param FULL_TENANT_NAME string
param B2C_REDIRECT_URL string
// ====================================== VARIABLES ============================================ //
var wellKnown = {
  MSGRAPH_APP_ID: '00000003-0000-0000-c000-000000000000'
  MSGRAPH_APP_WEBAPI_PERMISSIONS: {
    openid: '37f7f235-527c-4136-accd-4a02d197296e'
    offline_access: '7427e0e9-2fba-42fe-b0c0-848c9e6a8182'
    'User.ReadWrite.All': 'e0a7cdbb-08b0-4697-8264-0069786e9674'
    'User.ManageIdentities.All': '637d7bec-b31e-4deb-acc9-24275642a2c9'
    'Group.ReadWrite.All': '4e46008b-f24c-477d-8fff-7bb4ec7aafe0'
    'Policy.ReadWrite.TrustFramework': 'cefba324-1a70-4a6e-9c1d-fd670b7ae392'
  }
}

var IdentityExperienceFramework_NAME = 'IdentityExperienceFramework'
var IdentityExperienceFramework_SCOPE = 'user_impersonation'
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
  identifierUris: [
    'https://${FULL_TENANT_NAME}'
  ]
  api: {
    oauth2PermissionScopes: [
      {
        adminConsentDescription: 'Allow the application to access IdentityExperienceFramework on behalf of the signed-in user.'
        adminConsentDisplayName: 'Access IdentityExperienceFramework'
        isEnabled: true
        id: guid(FULL_TENANT_NAME)
        type: 'Admin'
        userConsentDescription: null
        userConsentDisplayName: null
        value: IdentityExperienceFramework_SCOPE
      }
    ]
  }
  requiredResourceAccess: [
    {
      resourceAppId: wellKnown.MSGRAPH_APP_ID
      resourceAccess: [
        {
          id: wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS.openid
          type: 'Scope'
        }
        {
          id: wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS.offline_access
          type: 'Scope'
        }
      ]
    }
  ]
}

var ProxyIdentityExperienceFramework_NAME = 'ProxyIdentityExperienceFramework'
resource ProxyIdentityExperienceFramework_APP 'Microsoft.Graph/applications@v1.0' = {
  uniqueName: ProxyIdentityExperienceFramework_NAME
  displayName: ProxyIdentityExperienceFramework_NAME
  signInAudience: 'AzureADMyOrg'
  publicClient: {
    redirectUris: ['myapp://auth']
  }
  isFallbackPublicClient: true
  requiredResourceAccess: [
    {
      resourceAppId: IdentityExperienceFramework_APP.appId
      resourceAccess: [
        {
          id: IdentityExperienceFramework_APP.api.oauth2PermissionScopes[0].id
          type: 'Scope'
        }
      ]
    }
    {
      resourceAppId: wellKnown.MSGRAPH_APP_ID
      resourceAccess: [
        {
          id: wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS.openid
          type: 'Scope'
        }
        {
          id: wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS.offline_access
          type: 'Scope'
        }
      ]
    }
  ]
}

// resource IdentityExperienceFramework_SP 'Microsoft.Graph/servicePrincipals@v1.0' = {
//   appId: IdentityExperienceFramework_APP.appId
// }

// resource identityExperienceFrameworkApiScope 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = {
//     consentType: 'AllPrincipals'
//     clientId: IdentityExperienceFramework_SP.id
//     scope: IdentityExperienceFramework_SCOPE
//     resourceId: MSGRAPH_SP.id
// }

// resource IdentityExperienceFramework_PERMISSION_GRANT_MSGRAPH 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = {
//   clientId: IdentityExperienceFramework_SP.id
//   consentType: 'AllPrincipals'
//   resourceId: MSGRAPH_SP.id
//   scope: wellKnown.MSGRAPH_DEFAULT_SCOPE
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
