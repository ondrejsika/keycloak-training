terraform {
  required_providers {
    keycloak = {
      source = "keycloak/keycloak"
    }
  }
}

variable "keycloak_url" {}

provider "keycloak" {
  client_id = "admin-cli"
  url       = var.keycloak_url
  username  = "admin"
  password  = "admin"
}
