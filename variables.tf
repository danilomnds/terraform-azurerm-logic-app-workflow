variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "access_control" {
  type = object({
    action = optional(object({
      allowed_caller_ip_address_range = list(string)
    }))
    content = optional(object({
      allowed_caller_ip_address_range = list(string)
    }))
    trigger = optional(object({
      allowed_caller_ip_address_range = list(string)
      open_authentication_policy = optional(object({
        name = string
        claim = object({
          name  = string
          value = string
        })
      }))
    }))
    workflow_management = optional(object({
      allowed_caller_ip_address_range = list(string)
    }))
  })
}

variable "identity" {
  description = "Specifies the type of Managed Service Identity that should be configured on this resource"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "integration_service_environment_id" {
  type    = string
  default = null
}

variable "logic_app_integration_account_id" {
  type    = string
  default = null
}

variable "enabled" {
  type       = bool
  defdefault = true
}

variable "workflow_parameters" {
  type    = map(string)
  default = {}
}

variable "workflow_schema" {
  type    = string
  default = "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#"
}

variable "workflow_version" {
  type    = string
  default = "1.0.0.0"
}

variable "parameters" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "azure_ad_groups" {
  type    = list(string)
  default = []
}