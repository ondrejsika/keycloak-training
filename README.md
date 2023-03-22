[Ondrej Sika (sika.io)](https://sika.io) | <ondrej@sika.io>

# Keycloak Training

## Install Keycloak

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
      values: |
        host: keycloak-dev.k8s.sikademo.com
```

Keycloak will be available on <https://keycloak-dev.k8s.sikademo.com>. Admin user is `admin` and password is `admin`.

## Install Production Keycloak to Kubernetes using Helm

```
helm upgrade --install \
  keycloak-prod \
  keycloak \
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
    targetRevision: 13.0.2
    chart: keycloak
    helm:
      releaseName: keycloak-prod
      values: |
        # https://github.com/bitnami/charts/blob/main/bitnami/keycloak/values.yaml
        replicaCount: 1
        image:
          repository: sikalabs/bitnami-keycloak-sikalabs-theme
          tag: 20.0.3-debian-11-r5
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
          hostname: sso.sikalabs.com
          annotations:
            kubernetes.io/ingress.class: nginx
            nginx.ingress.kubernetes.io/proxy-body-size: 250m
            nginx.ingress.kubernetes.io/proxy-buffer-size: "64k"
        postgresql:
          auth:
            postgresPassword: pg
            password: pg
```

Keycloak will be available on <https://keycloak-prod.k8s.sikademo.com>. Admin user is `admin` and password is `admin`.

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
  url       = "https://keycloak.sikademo.com"
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
  display_name_html      = "<h1>Example SSO</h1>"
}
```

```sh
terraform apply
```

Add email configuration

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
