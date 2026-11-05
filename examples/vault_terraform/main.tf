variable "admin_password_hash" {}

module "vault" {
  source = "git::ssh://git@gitlab.sikalabs.com/sikalabs-platform-terraform/sikalabs-platform-terraform-module-vault.git"

  vault_address       = var.vault_address
  admin_password_hash = var.admin_password_hash
  oidc_discovery_url  = "https://sso.sikalabs.com/realms/training"
  oidc_client_id      = "vault"
  oidc_client_secret  = "vault"
}

# Separate JWT auth mount for direct JWT login (eg. ID Token from device code flow)
# Mount with oidc_client_id + oidc_client_secret supports only OIDC (browser)
# flow, JWT login needs a mount with oidc_discovery_url only
resource "vault_jwt_auth_backend" "jwt" {
  description        = "Keycloak JWT"
  path               = "jwt"
  oidc_discovery_url = "https://sso.sikalabs.com/realms/training"
  default_role       = "jwt"
}

# POST /v1/auth/jwt/login {"role": "jwt", "jwt": "<id_token>"}
resource "vault_jwt_auth_backend_role" "jwt" {
  backend         = vault_jwt_auth_backend.jwt.path
  role_name       = "jwt"
  role_type       = "jwt"
  user_claim      = "sub"
  bound_audiences = ["vault"]
  token_policies  = ["read-all-secrets"]
}
