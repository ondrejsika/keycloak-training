resource "keycloak_user" "users" {
  for_each = local.users

  realm_id = keycloak_realm.example.id
  username = each.key
  enabled  = each.value.enabled

  email          = each.value.email
  email_verified = true
  first_name     = each.value.first_name
  last_name      = each.value.last_name

  attributes = {
    department = each.value.department
  }

  initial_password {
    value     = "a"
    temporary = true
  }
}

resource "keycloak_user_groups" "user_groups" {
  for_each = local.users

  realm_id = keycloak_realm.example.id
  user_id  = keycloak_user.users[each.key].id

  group_ids = each.value.group_ids
}
