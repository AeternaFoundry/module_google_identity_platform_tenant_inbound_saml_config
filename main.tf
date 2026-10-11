resource "google_identity_platform_tenant_inbound_saml_config" "identity_platform_tenant_inbound_saml_configs" {
  for_each = var.identity_platform_tenant_inbound_saml_configs

  display_name    = each.value.display_name
  name            = each.value.name
  tenant          = each.value.tenant
  deletion_policy = each.value.deletion_policy
  enabled         = each.value.enabled
  project         = each.value.project

  idp_config {
    dynamic "idp_certificates" {
      for_each = each.value.idp_config.idp_certificates
      content {
        x509_certificate = idp_certificates.value.x509_certificate
      }
    }
    idp_entity_id = each.value.idp_config.idp_entity_id
    sign_request  = each.value.idp_config.sign_request
    sso_url       = each.value.idp_config.sso_url
  }

  sp_config {
    callback_uri = each.value.sp_config.callback_uri
    sp_entity_id = each.value.sp_config.sp_entity_id
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

