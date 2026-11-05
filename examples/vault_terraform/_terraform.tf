terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.5.0"
    }
  }
}

variable "vault_address" {}
variable "vault_token" {}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}
