
func trimStringParam(arg string)string => toLower(replace(arg, ' ', ''))

func removeDashesFromString(arg string)string => '${replace(replace(trimStringParam(arg), '-', ''), '_', '')}'

@export()
func createTenantName(tenantName string, env string)string => '${removeDashesFromString(tenantName)}${env}.onmicrosoft.com'

@export()
func createStorageName(projectName string)string => '${removeDashesFromString('strg${projectName}')}'

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
func createWebAppName(projectName string, env string)string => 'web-${removeDashesFromString(projectName)}-${removeDashesFromString(env)}'

@export()
func createStorageConnectionString(storageName string, storageKey string)string => 'DefaultEndpointsProtocol=https;AccountName=${storageName};AccountKey=${storageKey};EndpointSuffix=${environment().suffixes.storage}'
