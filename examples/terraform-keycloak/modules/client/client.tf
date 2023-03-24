
terraform {
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
    }
  }
}

variable "realm_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "access_type" {}
variable "roles" {}
variable "full_scope_allowed" {
  default = false
}

resource "keycloak_openid_client" "this" {
  realm_id                        = var.realm_id
  client_id                       = var.client_id
  client_secret                   = var.client_secret
  enabled                         = true
  standard_flow_enabled           = true
  access_type                     = var.access_type # "PUBLIC" or "CONFIDENTIAL"
  valid_redirect_uris             = ["*"]
  valid_post_logout_redirect_uris = ["*"]
  web_origins                     = ["*"]
  full_scope_allowed              = var.full_scope_allowed
}

resource "keycloak_openid_user_attribute_protocol_mapper" "department" {
  realm_id            = var.realm_id
  client_id           = keycloak_openid_client.this.id
  name                = "department"
  user_attribute      = "department"
  claim_name          = "department"
  add_to_access_token = true
  add_to_id_token     = true
  add_to_userinfo     = true
}

resource "keycloak_openid_group_membership_protocol_mapper" "groups" {
  realm_id   = var.realm_id
  client_id  = keycloak_openid_client.this.id
  name       = "groups"
  claim_name = "groups"
}

resource "keycloak_openid_user_realm_role_protocol_mapper" "role_names" {
  realm_id    = var.realm_id
  client_id   = keycloak_openid_client.this.id
  name        = "role_names"
  claim_name  = "role_names"
  multivalued = true
}

resource "keycloak_openid_audience_protocol_mapper" "audience" {
  realm_id                 = var.realm_id
  client_id                = keycloak_openid_client.this.id
  name                     = "audience"
  included_client_audience = keycloak_openid_client.this.client_id
}

resource "keycloak_openid_client_default_scopes" "this" {
  realm_id  = var.realm_id
  client_id = keycloak_openid_client.this.id
  default_scopes = [
    "profile",
    "email",
    "roles",
    "department",
    "groups",
    "role_names",
  ]
}

resource "keycloak_role" "this" {
  for_each = { for role in var.roles : role => role }

  realm_id  = var.realm_id
  client_id = keycloak_openid_client.this.id
  name      = each.key
}

output "roles" {
  value = keycloak_role.this
}
