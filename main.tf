resource "azurerm_logic_app_workflow" "logic_app_workflow" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  /*
  Error: The terraform-provider-azurerm_v3.63.0_x5 plugin crashed!

  This is always indicative of a bug within the plugin. It would be immensely
  helpful if you could report the crash with the plugin's maintainers so that it
  can be fixed. The output above should help diagnose the issue.
  */

  /*
  dynamic "access_control" {
    for_each = var.access_control != null ? [var.access_control] : []
    content {
      dynamic "action" {
        for_each = access_control.value.action != null ? [access_control.value.action] : []
        content {
          allowed_caller_ip_address_range = action.value.allowed_caller_ip_address_range
        }
      }
      dynamic "content" {
        for_each = access_control.value.content != null ? [access_control.value.content] : []
        content {
          allowed_caller_ip_address_range = content.value.allowed_caller_ip_address_range          
        }
      }
      dynamic "trigger" {
        for_each = access_control.value.trigger != null ? [access_control.value.trigger] : []
        content {
          allowed_caller_ip_address_range = trigger.value.allowed_caller_ip_address_range
          dynamic "open_authentication_policy" {
            for_each = trigger.value.open_authentication_policy != null ? [trigger.value.open_authentication_policy] : []
            content {
              name = open_authentication_policy.value.name
              dynamic "claim" {
                for_each = open_authentication_policy.value.claim != null ? [open_authentication_policy.value.claim] : []
                content {
                  name = claim.value.name
                  value = claim.value.value
                }
              }
            }
          }
        }
      }
      dynamic "workflow_management" {
        for_each = access_control.value.workflow_management != null ? [access_control.value.workflow_management] : []
        content {
          allowed_caller_ip_address_range = workflow_management.value.allowed_caller_ip_address_range
        }
      }
    }
  }*/
  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
  integration_service_environment_id = var.integration_service_environment_id
  logic_app_integration_account_id   = var.logic_app_integration_account_id
  enabled                            = var.enabled
  workflow_parameters                = var.workflow_parameters
  workflow_schema                    = var.workflow_schema
  workflow_version                   = var.workflow_version
  parameters                         = var.parameters
  tags                               = local.tags
  lifecycle {
    ignore_changes = [
      tags["create_date"]
    ]
  }
}

resource "azurerm_role_assignment" "rg_scope_contributor" {
  depends_on = [ azurerm_logic_app_workflow.logic_app_workflow ]
  for_each = {
    for group in var.azure_ad_groups : group => group
    if var.rbac_scope_rg && var.azure_ad_groups != []
  } 
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Logic App Contributor"
  principal_id         = each.value
  lifecycle {
    ignore_changes = [
      scope
    ]
  }
}

resource "azurerm_role_assignment" "logic_app_scope_contributor" {
  depends_on = [ azurerm_logic_app_workflow.logic_app_workflow ]
  for_each = {
    for group in var.azure_ad_groups : group => group
    if var.rbac_scope_logic_app && var.azure_ad_groups != []
  } 
  scope                = azurerm_logic_app_workflow.logic_app_workflow.id
  role_definition_name = "Logic App Contributor"
  principal_id         = each.value
  lifecycle {
    ignore_changes = [
      scope
    ]
  }
}