resource "azurerm_logic_app_workflow" "logic_app_workflow" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dynamic "access_control" {
    for_each = var.access_control != null ? [var.access_control] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
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

resource "azurerm_role_assignment" "redis_contributor" {
  for_each             = var.azure_ad_groups != [] ? toset(var.azure_ad_groups) : []
  scope                = azurerm_redis_cache.redis.id
  role_definition_name = "Logic App Contributor"
  principal_id         = each.value
}