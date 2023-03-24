terraform {
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
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
