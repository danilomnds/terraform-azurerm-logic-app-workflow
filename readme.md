# Module - Azure Logic App Workflow
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()
[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

Module developed to standardize the Logic App Workflow creation.

## Compatibility Matrix

| Module Version | Terraform Version | AzureRM Version |
|----------------|-------------------| --------------- |
| v1.0.0         | v1.5.2            | 3.64.0          |

## Specifying a version

To avoid that your code get updates automatically, is mandatory to set the version using the `source` option. 
By defining the `?ref=***` in the the URL, you can define the version of the module.

Note: The `?ref=***` refers a tag on the git module repo.

## Important note

This module grantees the role "Logic App Contributor" for the azure AD groups listed using the var azure_ad_groups.
You can grantee this privilege in two different scopes, the rg scope and resource scope. 

Ex: In order to create an API Connection for sharepoint, the group should have the Logic App Contributor on resource group scope, because a new API Connect resource will be created.

## Use case

```hcl
module "<logic-system-env-001>" {
  source = "git::https://github.com/danilomnds/terraform-azurerm-logic-app-workflow?ref=v1.0.0" 
  name = "<logic-system-env-001>"
  location = "<your-region>"
  resource_group_name = "<resource-group>"
  azure_ad_groups = ["group id 1","group id 2"]
  # if you are creating more than one, please specify true once.
  rbac_scope_rg = true
  tags = {
    key1 = "value1"
    key2 = "value2"    
  }  
}
output "logic-system-env-001-name" {
  value = module.<logic-system-env-001>.name
}
output "logic-system-env-001-id" {
  value = module.<logic-system-env-001>.id
}
```

## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | logic app name | `string` | n/a | `Yes` |
| location | azure region | `string` | n/a | `Yes` |
| resource_group_name | resource group name where the resource(s) will be created | `string` | n/a | `Yes` |
| access_control (`not supported due to a bug`)| block as defined below | `object({})` | `{}` | No |
| identity | block as defined below | `object({})` | `{}` | No |
| family | the sku family/pricing group to use | `string` | `C` | `Yes` |
| integration_service_environment_id | the id of the integration service environment to which this logic app workflow belongs | `string` | `null` | No |
| logic_app_integration_account_id | the id of the integration account linked by this logic app workflow | `string` | `null` | No |
| enabled | is the logic app workflow enabled | `bool` | `true` | No |
| workflow_parameters | specifies a map of key-value pairs of the parameter definitions to use for this logic app workflow | `map(string)` | `{}` | No |
| workflow_schema | specifies the schema to use for this logic app workflow | `string` | `https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#` | No |
| workflow_version | specifies the version of the schema used for this logic app workflow | `string` | `1.0.0.0` | No |
| parameters | a map of key-value pairs | `map(string)` | `{}` | No |
| tags | tags for the resource | `map(string)` | `{}` | No |
| azure_ad_groups | list of azure AD groups that will be granted the Application Insights Component Contributor role  | `list` | `[]` | No |
| rbac_scope_rg | Will the role Logic App Contributor be granted on resource group scope?. If you are creating more than one, you have to set this var to true once.  | `bool` | `false` | No |
| rbac_scope_logic_app | Will the role Logic App Contributor be granted on resource?  | `bool` | `false` | No |

# Objects. List of acceptable parameters
| Variable Name (Block) | Parameter | Description | Type | Default | Required |
|-----------------------|-----------|-------------|------|---------|:--------:|
| identity | type | pecifies the type of Managed Service Identity that should be configured | `string` | `null` | No |
| identity | identity_ids | Specifies a list of User Assigned Managed Identity IDs to be assigned to resource | `liststring()` | `null` | No |
| access_control | action (sub-block optional) allowed_caller_ip_address_range | a list of the allowed caller ip address ranges | `string` | `null` | `Yes` |
| access_control | content (sub-block optional) allowed_caller_ip_address_range | a list of the allowed caller ip address ranges | `string` | `null` | `Yes` |
| access_control | trigger (sub-block optional) allowed_caller_ip_address_range | a list of the allowed caller ip address ranges| `string` | `null` | `Yes` |
| access_control | trigger (sub-block optional) open_authentication_policy (sub-block2 optional) name | the oauth policy name for the logic app workflow | `string` | `null` | `Yes` |
| access_control | trigger (sub-block optional)  open_authentication_policy (sub-block2 optional) claim (sub-block3 optional) name| the name of the oauth policy claim for the logic app workflow | `string` | `null` | `Yes` |
| access_control | trigger (sub-block optional)  open_authentication_policy (sub-block2 optional) claim (sub-block3 optional) value| the value of the oauth policy claim for the logic app workflow | `string` | `null` | `Yes` |
| access_control | workflow_management (sub-block) | a list of the allowed caller ip address ranges | `string` | `null` | `Yes` |

## Output variables

| Name | Description |
|------|-------------|
| name | Logic App name |
| id | Logic App id |

## Documentation

Terraform Azure Cache for Redis: <br>
[https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_workflow](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_workflow)<br>