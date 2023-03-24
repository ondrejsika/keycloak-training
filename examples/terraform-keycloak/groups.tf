module "group--admins" {
  source = "./modules/group"

  realm_id = keycloak_realm.example.id
  name     = "admins"
  role_ids = [
    module.client--example.roles["administrator"].id,
    module.client--example.roles["editor"].id,
    module.client--example.roles["uzivatel"].id,
    module.client--example.roles["viewer"].id,
    module.client--foo.roles["administrator"].id,
    module.client--bar.roles["editor"].id,
  ]
}

module "group--editors" {
  source = "./modules/group"

  realm_id = keycloak_realm.example.id
  name     = "editors"
  role_ids = []
}

module "group--viewers" {
  source = "./modules/group"

  realm_id = keycloak_realm.example.id
  name     = "viewers"
  role_ids = [
    module.client--example.roles["uzivatel"].id,
    module.client--example.roles["viewer"].id,
    module.client--foo.roles["uzivatel"].id,
    module.client--bar.roles["viewer"].id,
  ]
}

module "group--argocd-admins" {
  source = "./modules/group"

  realm_id = keycloak_realm.example.id
  name     = "argocd-admins"
  role_ids = []
}

module "group--argocd-viewers" {
  source = "./modules/group"

  realm_id = keycloak_realm.example.id
  name     = "argocd-viewers"
  role_ids = []
}
