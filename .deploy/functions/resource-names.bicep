
func trimStringParam(arg string)string => toLower(replace(arg, ' ', ''))

func removeDashesFromString(arg string)string => '${replace(replace(trimStringParam(arg), '-', ''), '_', '')}'

@export()
func createShortTenantName(projectName string, env string)string => '${removeDashesFromString(projectName)}${env}'

@export()
func createFullTenantName(shortTenantName string)string => '${shortTenantName}.onmicrosoft.com'

@export()
func createStorageName(projectName string, env string)string => '${removeDashesFromString('strg${projectName}${env}')}'

@export()
func createManagmentGroupName(orgName string)string => 'mg-${removeDashesFromString(orgName)}'

@export()
func createSubscriptionName(projectName string, location string)string => 'sub-${removeDashesFromString(projectName)}-${removeDashesFromString(location)}'

@export()
func createResourceGroupName(projectName string, location string, env string)string => 'rg-${removeDashesFromString(projectName)}-${removeDashesFromString(location)}-${removeDashesFromString(env)}'

@export()
func createBudgetName(subName string)string => 'budget-${subName}'

@export()
func createAppServiceName(projectName string, location string, env string)string => 'hosting-${removeDashesFromString(projectName)}-${removeDashesFromString(location)}-${removeDashesFromString(env)}'

@export()
func createDefaultWebAppDomain(webAppName string) string => 'https://${webAppName}.azurewebsites.net'

@export()
func createStorageConnectionString(storageName string, storageKey string)string => 'DefaultEndpointsProtocol=https;AccountName=${storageName};AccountKey=${storageKey};EndpointSuffix=${environment().suffixes.storage}'

@export()
func createB2CapplicationRedirectUri(tenantName string) string => 'https://${tenantName}.b2clogin.com/${tenantName}.onmicrosoft.com'

@export()
func createCongitiveServiceName(projectName string, env string) string => 'copmuter-vision-${removeDashesFromString(projectName)}-${removeDashesFromString(env)}'
