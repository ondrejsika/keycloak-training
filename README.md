[Ondrej Sika (sika.io)](https://sika.io) | <ondrej@sika.io>

# Keycloak Training

## Related Repositories

- https://github.com/ondrejsika/nextjs-auth-minimal-example

## Install Keycloak

https://www.keycloak.org/guides

## Install using Docker Compose

See example in [examples/docker_compose](examples/docker_compose)

```sh
cd examples/docker-compose
```

```sh
docker-compose up -d
```

## Install Development Keycloak to Kubernetes using Helm

```
helm upgrade --install \
  keycloak-dev \
  simple-keycloak \
  --repo https://helm.sikalabs.io \
  --namespace keycloak-dev \
  --create-namespace \
  --set host=keycloak-dev.k8s.sikademo.com
```

Keycloak will be available on <https://keycloak-dev.k8s.sikademo.com>. Admin user is `admin` and password is `admin`.

## Install Development Keycloak to Kubernetes using ArgoCD

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: keycloak-dev
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  destination:
    namespace: keycloak-dev
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
  source:
    repoURL: https://github.com/sikalabs/charts.git
    targetRevision: HEAD
    path: charts/simple-keycloak
    helm:
      releaseName: keycloak-dev
      valuesObject:
        host: keycloak-dev.k8s.sikademo.com
```

Keycloak will be available on <https://keycloak-dev.k8s.sikademo.com>. Admin user is `admin` and password is `admin`.

## Install Production Keycloak to Kubernetes using Helm

```
helm upgrade --install \
  keycloak-prod \
  keycloak \
  --version 22.2.1 \
  --repo https://charts.bitnami.com/bitnami \
  --namespace keycloak-prod \
  --create-namespace \
  --values examples/helm-values/keycloak-prod.yaml
```

Keycloak will be available on <https://keycloak-prod.k8s.sikademo.com>. Admin user is `admin` and password is `admin`.

## Install Production Keycloak to Kubernetes using ArgoCD

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: keycloak-prod
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  destination:
    namespace: keycloak-prod
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
  source:
    repoURL: https://charts.bitnami.com/bitnami
    targetRevision: 22.2.1
    chart: keycloak
    helm:
      releaseName: keycloak-prod
      valuesObject:
        # https://github.com/bitnami/charts/blob/main/bitnami/keycloak/values.yaml
        # https://artifacthub.io/packages/helm/bitnami/keycloak?modal=values
        replicaCount: 1
        image:
          repository: sikalabs/bitnami-keycloak-sikalabs-theme
          tag: 25.0.4-debian-12-r1
        auth:
          createAdminUser: true
          adminUser: admin
          adminPassword: admin
          managementUser: management
          managementPassword: management
        proxyAddressForwarding: true
        service:
          type: ClusterIP
        ingress:
          enabled: true
          hostname: sso.sikademo.com
          tls: true
          annotations:
            kubernetes.io/ingress.class: nginx
            nginx.ingress.kubernetes.io/proxy-body-size: 250m
            nginx.ingress.kubernetes.io/proxy-buffer-size: "64k"
            cert-manager.io/cluster-issuer: letsencrypt
        postgresql:
          auth:
            postgresPassword: pg
            password: pg
```

Keycloak will be available on <https://keycloak-prod.k8s.sikademo.com>. Admin user is `admin` and password is `admin`.

## Get Keycloak Version

Go to https://keycloak.sikademo.com/admin/master/console/#/master/info

## Keycloak Terraform Configuration

```terraform
terraform {
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
    }
  }
}

provider "keycloak" {
  client_id = "admin-cli"
  url       = "http://localhost:8080"
  username  = "admin"
  password  = "admin"
}
```

```sh
terraform init
```

## Realms

### What is Realm

Realm is a container for users, credentials, roles, groups and other entities. Each user belongs to and logs into a specific realm. Realms are isolated from one another and can only manage and authenticate the users that they control.

### Create Realm from UI

Go to <https://keycloak.sikademo.com> and login as `admin` with password `admin`. Click on `Add realm` button and fill the form.

### Create Realm using Terraform

```terraform
resource "keycloak_realm" "example" {
  realm                  = "example"
  enabled                = true
  display_name           = "Example SSO"
}
```

```sh
terraform apply
```

Extra configuration

Add email configuration (maildev in kubernetes)

```terraform
resource "keycloak_realm" "example" {
  realm                  = "example"
  enabled                = true
  display_name           = "Example SSO"
  display_name_html      = "<h1>Example SSO</h1>"
  reset_password_allowed = true
  smtp_server {
    host = "maildev-smtp.maildev"
    port = "25"
    from = "sso@example.com"
    auth {
      username = "xxx"
      password = "xxx"
    }
  }
}
```

Add email configuration (mailhog in docker compose)

```terraform
resource "keycloak_realm" "example" {
  realm                  = "example"
  enabled                = true
  display_name           = "Example SSO"
  display_name_html      = "<h1>Example SSO</h1>"
  reset_password_allowed = true
  smtp_server {
    host = "mailhog"
    port = "1025"
    from = "sso@example.com"
    auth {
      username = "xxx"
      password = "xxx"
    }
  }
}
```

## Users

### Create User from UI

You can add user here <https://keycloak.sikademo.com/admin/example/console/#/example/users>

### Create User using Terraform

```terraform
resource "keycloak_user" "ondrej" {
  realm_id = keycloak_realm.example.id
  username = "ondrej"
  enabled  = true

  email          = "ondrej@example.com"
  email_verified = true
  first_name     = "Ondrej"
  last_name      = "Sika"

  initial_password {
    value     = "a"
    temporary = true
  }
}
```

## Realm settings

### Login screen customization

- User registration
- Forgot password
- Remember me

### Email settings

- Email as username
- Login with email
- Duplicate emails
- Verify email

### User info settings

- Edit username

## Roles

### What is Role

Roles and groups have a similar purpose, which is to give users access and permissions to use applications. Groups are a collection of users to which you apply roles and attributes. Roles define specific applications permissions and access control.

A role typically applies to one type of user. For example, an organization may include admin, user, manager, and employee roles. An application can assign access and permissions to a role and then assign multiple users to that role so the users have the same access and permissions. For example, the Admin Console has roles that give permission to users to access different parts of the Admin Console.

### Create Role from UI

<https://keycloak.sikademo.com/admin/master/console/#/example/roles>

### Create Role using Terraform

```terraform
resource "keycloak_role" "editor" {
  realm_id = keycloak_realm.example.id
  name     = "editor"
}

resource "keycloak_role" "viewer" {
  realm_id = keycloak_realm.example.id
  name     = "viewer"
}
```

## Groups

### What is Group

Groups are a collection of users to which you apply roles and attributes. Roles define specific applications permissions and access control.

### Create Group from UI

<https://keycloak.sikademo.com/admin/master/console/#/example/groups>

### Create Group using Terraform

```terraform
resource "keycloak_group" "team-a" {
  realm_id = keycloak_realm.example.id
  name     = "team-a"
}

resource "keycloak_group" "team-b" {
  realm_id = keycloak_realm.example.id
  name     = "team-b"
}
```

## Assign users into Groups

### Assign User into Group from UI

<https://keycloak.sikademo.com/admin/master/console/#/example/users>

### Assign User into Group using Terraform

```terraform
resource "keycloak_user_groups" "ondrej" {
  realm_id = keycloak_realm.example.id
  user_id  = keycloak_user.ondrej.id
  group_ids = [
    keycloak_group.team-b.id,
  ]
}
```

## Assign Roles

### Assign Role to User

```
resource "keycloak_user_roles" "ondrej" {
  realm_id = keycloak_realm.example.id
  user_id  = keycloak_user.ondrej.id

  role_ids = [
    keycloak_role.editor.id,
  ]
}
```

### Assign Role to Group

```
resource "keycloak_group_roles" "team-a" {
  realm_id = keycloak_realm.example.id
  group_id = keycloak_group.team-a.id

  role_ids = [
    keycloak_role.editor.id,
  ]
}

resource "keycloak_group_roles" "team-b" {
  realm_id = keycloak_realm.example.id
  group_id = keycloak_group.team-b.id

  role_ids = [
    keycloak_role.viewer.id,
  ]
}
```

## Clients

### What is Client

Clients are applications that can request authentication from Keycloak. Clients can be applications that are developed by your organization or third-party applications. When you create a client, you can specify the type of client. For example, you can specify that the client is a confidential application that requires a secret to authenticate, or you can specify that the client is a public application that does not require a secret to authenticate.

### Create Client from UI

<https://keycloak.sikademo.com/admin/master/console/#/example/clients>

### Test Direct Access Grants

```sh
curl -X POST "https://keycloak.sikademo.com/realms/test/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=default" \
  -d "client_secret=default" \
  -d "grant_type=password" \
  -d "username=user" \
  -d "password=a"
```

```sh
curl -X POST "https://keycloak.sikademo.com/realms/test/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=default" \
  -d "client_secret=default" \
  -d "grant_type=password" \
  -d "username=user" \
  -d "password=a" \
  -d "scope=openid"
```

### Create Client using Terraform

```terraform
resource "keycloak_openid_client" "example" {
  realm_id                        = keycloak_realm.example.id
  client_id                       = "example"
  client_secret                   = "example"
  enabled                         = true
  standard_flow_enabled           = true
  direct_access_grants_enabled    = true
  access_type                     = "PUBLIC" # or "CONFIDENTIAL"
  valid_redirect_uris             = ["*"]
  valid_post_logout_redirect_uris = ["*"]
  web_origins                     = ["*"]
}
```

## Client Scopes & Protocol Mappers

## Client Scopes

```terraform
resource "keycloak_openid_client_scope" "example_groups" {
  realm_id               = keycloak_realm.example.id
  name                   = "groups"
  include_in_token_scope = true
}
```

```terraform
data "keycloak_openid_client_scope" "example_roles" {
  realm_id = keycloak_realm.example.id
  name     = "roles"
}
```

## Protocol Mappers

### Group Membership Protocol Mapper

```terraform
resource "keycloak_openid_group_membership_protocol_mapper" "example_groups" {
  realm_id        = keycloak_realm.example.id
  client_scope_id = keycloak_openid_client_scope.example_groups.id

  name            = keycloak_openid_client_scope.example_groups.name
  claim_name      = keycloak_openid_client_scope.example_groups.name
  full_path       = false
}
```

### Realm Roles Protocol Mapper

```terraform
resource "keycloak_openid_user_realm_role_protocol_mapper" "example_roles" {
  realm_id        = keycloak_realm.example.id
  client_scope_id = data.keycloak_openid_client_scope.example_roles.id
  name            = data.keycloak_openid_client_scope.example_roles.id
  claim_name      = data.keycloak_openid_client_scope.example_roles.id
  multivalued     = true
}
```

## Default Client Scopes

```terraform
resource "keycloak_openid_client_default_scopes" "example" {
  realm_id  = keycloak_realm.example.id
  client_id = keycloak_openid_client.example.id
  default_scopes = [
    "profile",
    "email",
    keycloak_openid_client_scope.example_groups.name,
    data.keycloak_openid_client_scope.example_roles.name,
  ]
}
```

## Thank you! & Questions?

That's it. Do you have any questions? **Let's go for a beer!**

### Ondrej Sika

- email: <ondrej@sika.io>
- web: <https://sika.io>
- twitter: [@ondrejsika](https://twitter.com/ondrejsika)
- linkedin: [/in/ondrejsika/](https://linkedin.com/in/ondrejsika/)
- Newsletter, Slack, Facebook & Linkedin Groups: <https://join.sika.io>

_Do you like the course? Write me recommendation on Twitter (with handle `@ondrejsika`) and LinkedIn (add me [/in/ondrejsika](https://www.linkedin.com/in/ondrejsika/) and I'll send you request for recommendation). **Thanks**._

Wanna to go for a beer or do some work together? Just [book me](https://book-me.sika.io) :)
