locals {
  users = {
    "ondrej" = {
      email      = "ondrej@example.com"
      first_name = "Ondrej"
      last_name  = "Sika"
      enabled    = true
      group_ids = [
        module.group--admins.id,
        module.group--editors.id,
        module.group--viewers.id,
        module.group--argocd-admins.id,
      ]
      department = "IT"
    }
    "alice" = {
      email      = "alice@example.com"
      first_name = "Alice"
      last_name  = "Demo"
      enabled    = true
      group_ids = [
        module.group--editors.id,
        module.group--viewers.id,
        module.group--argocd-viewers.id,
      ]
      department = "Office"
    }
    "bob" = {
      email      = "bob@example.com"
      first_name = "Bob"
      last_name  = "Demo"
      enabled    = true
      group_ids = [
        module.group--viewers.id,
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
