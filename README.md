1. Install Azure CLI

```
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

// check version
az --version

// update
az upgrade

// P.S.
login into cli after you set all neccessary permissions for your user

```

2. Permissions

```
// elevate as Global Administrator
https://learn.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin?tabs=azure-portal

// add required permissions read:
https://github.com/Azure/Enterprise-Scale/wiki/ALZ-Setup-azure

or

// assign Owner role at Tenant root scope ("/") as a User Access Administrator to current user (gets object Id of the current user (az login))
az role assignment create --scope '/' --role 'Owner' --assignee-object-id $(az ad signed-in-user show --query id --output tsv) --assignee-principal-type User

or
Open Microsoft Entra ID ->  Under Manage, select Properties. -> Under Access management for Azure resources, set the toggle to Yes.


// payment permissions elevate for user as billing profile owner
https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/view-all-accounts
```

3. Login / logout

```
az login
or
az login --use-device-code

az logout

```

4. Initial Deploy - creating Managment Group + Subscription under that managment group

- save billing info for creating subscription in managment-group

```
billingAccountName=$(az billing account list --query "[0].name" -o tsv)
echo $billingProfileName
billingProfileName=$(az billing account list-invoice-section --billing-account-name "$billingAccountName" --query "[0].billingProfileSystemId" -o tsv)
echo $billingProfileName
invoiceSectionName=$(az billing account list-invoice-section --billing-account-name "$billingAccountName" --query "[0].invoiceSectionSystemId" -o tsv)
echo $invoiceSectionName
```

- initialize deploy by runing command <B>correct parameters to real one</B> except from prev step

```
az deployment tenant create --name 'demodeploy' --location 'eastus2' --template-file './azure/main.bicep' --parameters projectName='demodeploy' environment='test' location='eastus2' billingAccountName="$billingAccountName" billingProfileName="$billingProfileName" invoiceSectionName="$invoiceSectionName"
```

// TODO:

- create subscription spending limit resource
- create resource group
- create tenant under rg
- create web app service plan (linux node)
- create web app service under plan
- create blob storage account
- create key-value resource
- create computer vision resource

- create db

4. Helpfull commands

```

// signed in user id
az ad signed-in-user show --query id --output tsv

// list managment-group
az account management-group list

// list subscriptions
az account subscription list

// list tenants
az account tenant list

// current subscription context
az account show --query name

// set subscription context
az account set --subscription "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

// list locations
az account list-locations


```
