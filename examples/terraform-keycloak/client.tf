module "example_client" {
  source = "./modules/client"

  realm_id      = keycloak_realm.example.id
  client_id     = "example"
  client_secret = ""
  access_type   = "PUBLIC"
  roles = [
    "administrator",
    "uzivatel",
    "editor",
    "viewer",
  ]
}

module "foo_client" {
  source = "./modules/client"

  realm_id      = keycloak_realm.example.id
  client_id     = "foo"
  client_secret = ""
  access_type   = "PUBLIC"
  roles = [
    "administrator",
    "uzivatel",
  ]
}

module "bar_client" {
  source = "./modules/client"

  realm_id      = keycloak_realm.example.id
  client_id     = "bar"
  client_secret = ""
  access_type   = "PUBLIC"
  roles = [
    "editor",
    "viewer",
  ]
}

module "oauth2_proxy_client" {
  source = "./modules/client"

  realm_id      = keycloak_realm.example.id
  client_id     = "oauth2_proxy"
  client_secret = "example"
  access_type   = "CONFIDENTIAL"
  roles         = []
}

module "argocd_client" {
  source = "./modules/client"

  realm_id      = keycloak_realm.example.id
  client_id     = "argocd"
  client_secret = "example"
  access_type   = "CONFIDENTIAL"
  roles         = []
}


module "example_service_client" {
  source = "./modules/client"

  realm_id      = keycloak_realm.example.id
  client_id     = "example-service"
  client_secret = "example"
  access_type   = "CONFIDENTIAL"
  roles = [
    "administrator",
    "uzivatel",
    "editor",
    "viewer",
  ]
  service_accounts_enabled = true
  service_account_roles = [
    "administrator"
  ]
}
