
terraform {
  required_providers {
    keycloak = {
      source = "keycloak/keycloak"
    }
  }
}

variable "realm_id" {}
variable "name" {}
variable "role_ids" {}

resource "keycloak_group" "this" {
  realm_id = var.realm_id
  name     = var.name
}

resource "keycloak_group_roles" "this" {
  realm_id = var.realm_id
  group_id = keycloak_group.this.id

  role_ids = var.role_ids
}

output "id" {
  value = keycloak_group.this.id
}
