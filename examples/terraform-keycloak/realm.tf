resource "keycloak_realm" "example" {
  realm                  = "example"
  enabled                = true
  display_name           = "SSO"
  display_name_html      = "<h1 style=\"color: red; font-size: 2em\">SSO</h1>"
  reset_password_allowed = true
  remember_me            = true
  smtp_server {
    host                  = "mailhog"
    port                  = "1025"
    from                  = "sso@example.com"
    from_display_name     = "Example SSO"
    reply_to              = "support@example.com"
    reply_to_display_name = "Example Support"
    auth {
      username = "xxx"
      password = "xxx"
    }
  }
}

resource "keycloak_realm_events" "example" {
  realm_id = keycloak_realm.example.id

  events_enabled               = true
  admin_events_enabled         = true
  admin_events_details_enabled = true

  enabled_event_types = []

  events_listeners = [
    "jboss-logging",
  ]
}

resource "keycloak_openid_client_scope" "groups" {
  realm_id               = keycloak_realm.example.id
  name                   = "groups"
  include_in_token_scope = true
}

resource "keycloak_openid_client_scope" "role_names" {
  realm_id               = keycloak_realm.example.id
  name                   = "role_names"
  include_in_token_scope = true
}

resource "keycloak_openid_client_scope" "department" {
  realm_id               = keycloak_realm.example.id
  name                   = "department"
  include_in_token_scope = true
}

resource "keycloak_openid_client_scope" "audience" {
  realm_id               = keycloak_realm.example.id
  name                   = "audience"
  include_in_token_scope = true
}
