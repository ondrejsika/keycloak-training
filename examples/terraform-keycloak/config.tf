locals {
  users = {
    "ondrej" = {
      email      = "ondrej@example.com"
      first_name = "Ondrej"
      last_name  = "Sika"
      enabled    = true
      group_ids = [
        module.admins_group.id,
        module.editors_group.id,
        module.viewers_group.id,
        module.argocd_admins_group.id,
      ]
      department = "IT"
    }
    "alice" = {
      email      = "alice@example.com"
      first_name = "Alice"
      last_name  = "Demo"
      enabled    = true
      group_ids = [
        module.editors_group.id,
        module.viewers_group.id,
        module.argocd_viewers_group.id,
      ]
      department = "Office"
    }
    "bob" = {
      email      = "bob@example.com"
      first_name = "Bob"
      last_name  = "Demo"
      enabled    = true
      group_ids = [
        module.viewers_group.id,
      ]
      department = "Trainee"
    }
    "charlie" = {
      email      = "charlie@example.com"
      first_name = "Charlie"
      last_name  = "Demo"
      enabled    = true
      group_ids  = []
      department = "Sales"
    }
  }
}
