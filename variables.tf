variable "identity_platform_tenant_inbound_saml_configs" {
  description = <<EOT
Map of identity_platform_tenant_inbound_saml_configs, attributes below
Required:
    - display_name
    - name
    - tenant
    - idp_config (block):
        - idp_certificates (required, block):
            - x509_certificate (optional)
        - idp_entity_id (required)
        - sign_request (optional)
        - sso_url (required)
    - sp_config (block):
        - callback_uri (required)
        - sp_entity_id (required)
Optional:
    - deletion_policy
    - enabled
    - project
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    display_name    = string
    name            = string
    tenant          = string
    deletion_policy = optional(string)
    enabled         = optional(bool)
    project         = optional(string)
    idp_config = object({
      idp_certificates = list(object({
        x509_certificate = optional(string)
      }))
      idp_entity_id = string
      sign_request  = optional(bool)
      sso_url       = string
    })
    sp_config = object({
      callback_uri = string
      sp_entity_id = string
    })
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.identity_platform_tenant_inbound_saml_configs : (
        length(v.idp_config.idp_certificates) >= 1
      )
    ])
    error_message = "Each idp_certificates list must contain at least 1 items"
  }
}

