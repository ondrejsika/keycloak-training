module "client--example" {
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

module "client--foo" {
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

module "client--bar" {
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

module "client--oauth2_proxy" {
  source = "./modules/client"

  realm_id      = keycloak_realm.example.id
  client_id     = "oauth2_proxy"
  client_secret = "example"
  access_type   = "CONFIDENTIAL"
  roles         = []
}

module "client--argocd" {
  source = "./modules/client"

  realm_id      = keycloak_realm.example.id
  client_id     = "argocd"
  client_secret = "example"
  access_type   = "CONFIDENTIAL"
  roles         = []
}
