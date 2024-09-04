import {createB2CapplicationRedirectUri} from '../../functions/resource-names.bicep'

extension microsoftGraph
// ====================================== BRIEF DESCRIPTION ==================================== //
// ====================================== GETTING STARTED ====================================== //
// ====================================== PARAMETERS =========================================== //
param FULL_TENANT_NAME string
param B2C_REDIRECT_URL string
param WEB_APP_DOMAIN string

// param certKey string 
// param certStartDate string 
// param certEndDate string
// ====================================== VARIABLES ============================================ //
var wellKnown = {
  MSGRAPH_APP_ID: '00000003-0000-0000-c000-000000000000'
  MSGRAPH_APP_WEBAPI_PERMISSIONS: {
    openid: '37f7f235-527c-4136-accd-4a02d197296e'
    offline_access: '7427e0e9-2fba-42fe-b0c0-848c9e6a8182'
    'User.ReadWrite.All': '204e0828-b5ca-4ad8-b9f3-f32a958e7cc4'
    'User.ManageIdentities.All': '637d7bec-b31e-4deb-acc9-24275642a2c9'
    'Group.ReadWrite.All': '4e46008b-f24c-477d-8fff-7bb4ec7aafe0'
    'Policy.ReadWrite.TrustFramework': 'cefba324-1a70-4a6e-9c1d-fd670b7ae392'
  }
}

var MS_GRAPH_IDENTITY_ROLES = [
  {
    id: wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS.openid
    type: 'Scope'
  }
  {
    id: wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS.offline_access
    type: 'Scope'
  }
]

var MG_GRAPH_SERVER_ROLES = [
  ...MS_GRAPH_IDENTITY_ROLES
  {
    id: wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS['User.ReadWrite.All']
    type: 'Scope'
  }
  {
    id:wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS['User.ManageIdentities.All']
    type: 'Scope'
  }
  {
    id:wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS['Group.ReadWrite.All']
    type: 'Scope'
  }
  {
    id:wellKnown.MSGRAPH_APP_WEBAPI_PERMISSIONS['Policy.ReadWrite.TrustFramework']
    type: 'Scope'
  }
]

var IdentityExperienceFramework_NAME = 'IdentityExperienceFramework'
var ProxyIdentityExperienceFramework_NAME = 'ProxyIdentityExperienceFramework'
var ServerApplication_NAME = 'ServerApi'
var ClientApplicationSPA_NAME = 'ClientWebSPA'

var IdentityExperienceFramework_SCOPE = 'user_impersonation'
var ServerApplication_SCOPE = 'STANDARD.USER.API'

var IdentityExperienceFramework_URI = 'https://${FULL_TENANT_NAME}/${IdentityExperienceFramework_NAME}'
var ServerApplication_URI = 'https://${FULL_TENANT_NAME}/${ServerApplication_NAME}'
var ClientApplicationSPA_REDIRECTURLS = [
  WEB_APP_DOMAIN
  'http://localhost:3000'
  'https://jwt.ms'
]

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
  identifierUris: [IdentityExperienceFramework_URI]
  api: {
    oauth2PermissionScopes: [
      {
        adminConsentDescription: 'Allow the application to access IdentityExperienceFramework on behalf of the signed-in user.'
        adminConsentDisplayName: 'Access IdentityExperienceFramework'
        isEnabled: true
        id: guid(IdentityExperienceFramework_SCOPE)
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
      resourceAccess: MS_GRAPH_IDENTITY_ROLES
    }
  ]
}

resource IdentityExperienceFramework_SP 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: IdentityExperienceFramework_APP.appId
}

resource  IdentityExperienceFramework_ROLES 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = {
    principalId: null
    clientId: IdentityExperienceFramework_SP.id
    resourceId: MSGRAPH_SP.id
    consentType: 'AllPrincipals'
    scope: 'openid offline_access'
}


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
      resourceAccess: MS_GRAPH_IDENTITY_ROLES
    }
  ]
}

resource ProxyIdentityExperienceFramework_SP 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: ProxyIdentityExperienceFramework_APP.appId
}

resource  ProxyIdentityExperienceFramework_ROLES 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = {
  principalId: null
  clientId: ProxyIdentityExperienceFramework_SP.id
  resourceId: MSGRAPH_SP.id
  consentType: 'AllPrincipals'
  scope: 'openid offline_access'
}

resource  ProxyIdentityExperienceFramework_SHARED 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = {
  principalId: null
  clientId: ProxyIdentityExperienceFramework_SP.id
  resourceId: IdentityExperienceFramework_SP.id
  consentType: 'AllPrincipals'
  scope: IdentityExperienceFramework_SCOPE
}

resource ServerApplication_APP 'Microsoft.Graph/applications@v1.0' = {
  uniqueName: ServerApplication_NAME
  displayName: ServerApplication_NAME
  signInAudience: 'AzureADandPersonalMicrosoftAccount'
  identifierUris: [
    ServerApplication_URI
  ]
  keyCredentials: [
    // {
    //   displayName: 'Credential from KV'
    //   usage: 'Verify'
    //   type: 'AsymmetricX509Cert'
    //   key: certKey
    //   startDateTime: certStartDate
    //   endDateTime: certEndDate
    // }
  ]
  api: {
    oauth2PermissionScopes: [
      {
        adminConsentDescription: 'User in you app can use standard features provided by your api'
        adminConsentDisplayName: 'User in you app can use standard features provided by your api'
        isEnabled: true
        id: guid(ServerApplication_SCOPE)
        type: 'Admin'
        userConsentDescription: null
        userConsentDisplayName: null
        value: ServerApplication_SCOPE
      }
    ]
  }
  requiredResourceAccess: [
    {
      resourceAppId: wellKnown.MSGRAPH_APP_ID
      resourceAccess: MG_GRAPH_SERVER_ROLES
    }
  ]
}
resource ServerApplication_SP 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: ServerApplication_APP.appId
}

resource  ServerApplication_ROLES 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = {
  principalId: null
  clientId: ServerApplication_SP.id
  resourceId: MSGRAPH_SP.id
  consentType: 'AllPrincipals'
  scope: 'openid offline_access User.ReadWrite.All User.ManageIdentities.All Group.ReadWrite.All Policy.ReadWrite.TrustFramework'
}

resource ClientApplicationSPA_APP 'Microsoft.Graph/applications@v1.0' = {
  uniqueName: ClientApplicationSPA_NAME
  displayName: ClientApplicationSPA_NAME
  signInAudience: 'AzureADandPersonalMicrosoftAccount'
  isFallbackPublicClient: true
  spa: {
    redirectUris: ClientApplicationSPA_REDIRECTURLS
  }
  web: {
    implicitGrantSettings: {
      enableAccessTokenIssuance: true
      enableIdTokenIssuance: true
    }
  }
  requiredResourceAccess: [
    {
      resourceAppId: ServerApplication_APP.appId
      resourceAccess: [
        {
          id: ServerApplication_APP.api.oauth2PermissionScopes[0].id
          type: 'Scope'
        }
      ]
    }
    {
      resourceAppId: wellKnown.MSGRAPH_APP_ID
      resourceAccess: MS_GRAPH_IDENTITY_ROLES
    }
  ]
}

resource ClientApplicationSPA_SP 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: ClientApplicationSPA_APP.appId
}

resource  ClientApplicationSPA_ROLES 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = {
    principalId: null
    clientId: ClientApplicationSPA_SP.id
    resourceId: MSGRAPH_SP.id
    consentType: 'AllPrincipals'
    scope: 'openid offline_access'
}

resource  ClientApplicationSPA_SHARED 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = {
  principalId: null
  clientId: ClientApplicationSPA_SP.id
  resourceId: ServerApplication_SP.id
  consentType: 'AllPrincipals'
  scope: ServerApplication_SCOPE
}


output B2C_CLIENT_APPLICATION_ID string = ClientApplicationSPA_APP.appId
output B2C_SERVER_APPLICATION_ID string = ServerApplication_APP.appId
