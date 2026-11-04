module "admins_group" {
  source = "./modules/group"

  realm_id = keycloak_realm.example.id
  name     = "admins"
  role_ids = [
    module.example_client.roles["administrator"].id,
    module.example_client.roles["editor"].id,
    module.example_client.roles["uzivatel"].id,
    module.example_client.roles["viewer"].id,
    module.foo_client.roles["administrator"].id,
    module.bar_client.roles["editor"].id,
  ]
}

module "editors_group" {
  source = "./modules/group"

  realm_id = keycloak_realm.example.id
  name     = "editors"
  role_ids = []
}

module "viewers_group" {
  source = "./modules/group"

  realm_id = keycloak_realm.example.id
  name     = "viewers"
  role_ids = [
    module.example_client.roles["uzivatel"].id,
    module.example_client.roles["viewer"].id,
    module.foo_client.roles["uzivatel"].id,
    module.bar_client.roles["viewer"].id,
  ]
}

module "argocd_admins_group" {
  source = "./modules/group"

  realm_id = keycloak_realm.example.id
  name     = "argocd-admins"
  role_ids = []
}

module "argocd_viewers_group" {
  source = "./modules/group"

  realm_id = keycloak_realm.example.id
  name     = "argocd-viewers"
  role_ids = []
}
