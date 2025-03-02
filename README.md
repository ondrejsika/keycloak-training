[Ondrej Sika (sika.io)](https://sika.io) | <ondrej@sika.io>

# Keycloak Training

## Related Repositories

- https://github.com/ondrejsika/nextjs-auth-minimal-example

## Course

## About Me - Ondrej Sika

__Freelance DevOps Engineer, Consultant & Lecturer__

- Complete DevOps Pipeline
- Open Source / Linux Stack
- Cloud & On-Premise
- Technologies: Git, Gitlab, Gitlab CI, Docker, Kubernetes, Terraform, Prometheus, ELK / EFK, Rancher, Proxmox, DigitalOcean, AWS

## Star, Create Issues, Fork, and Contribute

Feel free to star this repository or fork it.

If you found bug, create issue or pull request.

Also feel free to propose improvements by creating issues.

## Chat

For sharing links & "secrets".

- Zoom Chat
- Slack - https://sikapublic.slack.com/
- Microsoft Teams
- https://sika.link/chat (tlk.io)

## DevOps Kniha (Czech only)

[![](./images/devops_kniha.jpg)](https://kniha.sika.io)

<https://kniha.sika.io>

## What is Keycloak

Keycloak is an open-source identity and access management (IAM) solution developed by Red Hat. It provides authentication and authorization services for applications and services.

## Key Features of Keycloak

- Single Sign-On (SSO): Users can log in once and access multiple applications without re-authenticating.
- Identity Brokering: Supports authentication via third-party identity providers like Google, Microsoft, or LDAP.
- User Federation: Integrates with existing user directories (LDAP, Active Directory).
- Multi-Factor Authentication (MFA): Supports OTP, WebAuthn, and other MFA mechanisms.
- Fine-Grained Authorization: Offers Role-Based Access Control (RBAC) and Attribute-Based Access Control (ABAC).
- Protocol Support: Works with OpenID Connect (OIDC) and SAML.
- Admin UI, API, and Terraform: Provides an easy-to-use management interface and REST APIs for automation.
- Self-Service Account Management: Users can manage their profiles, passwords, and sessions.

## Authentication vs Authorization

In OIDC & Keycloak, authentication happens via OpenID Connect (OIDC), while authorization is managed via roles, groups, or policies in Keycloak.

### Authentication (AuthN) – Confirms who you are.

- It verifies a user’s identity (e.g., username & password, MFA, or single sign-on).
- Example: Logging into a system with a password.

### Authorization (AuthZ) – Determines what you can do.

- It controls access to resources based on permissions and roles.
- Example: A logged-in user can view their profile but not access admin settings.

### Key Difference

- Authentication
  - Identity verification
  - Are you who you claim to be?
- Authorization
  - Access control
  - What are you allowed to do?

## OAuth 2.0 vs OpenID Connect (OIDC)

OAuth 2.0 and OpenID Connect (OIDC) are related but serve different purposes

### OAuth 2.0

- Purpose: Authorization framework.
- What it does: Allows users to grant third-party applications access to their resources without sharing credentials.
- Example Use Case: A user logs into a service using "Sign in with Google", granting the app access to their Google Drive files.
- Tokens: Issues an access token that applications use to access APIs on behalf of the user.
- No Identity Information: OAuth alone does not provide user authentication or identity details.

### OpenID Connect (OIDC)

- Purpose: Authentication layer on top of OAuth 2.0.
- What it does: Verifies user identity and provides user profile information.
- Example Use Case: A user logs into an application using “Sign in with Google,” and the application gets their email and profile info.
- Tokens: Issues an ID token (JWT) containing user identity details (like name, email, etc.), along with an access token.
- Identity Information: Designed to authenticate users, making it useful for Single Sign-On (SSO).

### Key Difference

- OAuth 2.0 is for authorization (who can access what).
- OIDC is for authentication (who the user is).

If you're building a system that requires logging in users securely, you should use OIDC. If you only need to access APIs on behalf of users, OAuth 2.0 is sufficient.

## JWT (JSON Web Token)

JSON Web Token (JWT) is an open standard (RFC 7519) that defines a compact, URL safe, and self-contained way for securely transmitting information between parties as a JSON object. This information can be verified and trusted because it is digitally signed.

It is commonly used for authentication and authorization in web applications.

### Structure of JWT

A JWT consists of three parts, separated by dots (`.`)

1. Header – Contains metadata, such as the token type (JWT) and signing algorithm (e.g., HS256, RS256).
2. Payload – Contains claims (statements about the user or token), such as user ID, roles, or expiration time.
3. Signature – Ensures the integrity of the token using a secret key or public/private key pair.

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

### How JWT Works in Authentication

1. A user logs in and receives a JWT from the server.
2. The client stores the token (e.g., in localStorage or an HTTP-only cookie).
3. With each request, the client includes the JWT in the Authorization header (`Bearer <token>`).
4. The server verifies the JWT’s signature and extracts the payload to determine if the request is authorized.

### Pros of JWT

- Stateless (no need for server-side sessions)
- Compact and efficient (can be sent in headers or URLs)
- Supports various cryptographic algorithms

### Cons of JWT

- Cannot be revoked easily (unless using short expiration and refresh tokens)
- Large payloads increase token size
- Sensitive data should not be stored in the payload, as it can be decoded without the secret key

### Parse JWT

You can use: https://jwt.io

or use `slu jwt parse` command

```
slu jwt parse eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c | jq
```

Output:

```json
[
  {
    "alg": "HS256",
    "typ": "JWT"
  },
  {
    "iat": 1516239022,
    "name": "John Doe",
    "sub": "1234567890"
  },
  "SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
]
```

## OAuth 2.0 Tokens

OAuth 2.0 defines several types of tokens used for different purposes in the authentication and authorization process.

### Access Token

- Grants access to protected resources on behalf of the user.
- Sent in API requests (e.g., Authorization: Bearer <token>).
- Typically short-lived for security reasons.
- Format varies (JWT, opaque string, etc.), depending on the authorization server.

### Refresh Token

- Used to obtain a new access token without requiring user interaction.
- Long-lived but can be revoked by the authorization server.
- Not always issued (depends on grant type and server configuration).
- Should be stored securely, as it can be used to generate new access tokens.

OAuth2 does not define ID tokens (those are part of OIDC). It primarily focuses on authorization, not authentication.

## OIDC Tokens

In OpenID Connect (OIDC), which is an identity layer built on top of OAuth2, additional tokens are used:

### ID Token

- A JWT (JSON Web Token) that contains identity information about the authenticated user.
- Issued by the OpenID Provider after successful authentication.
- Includes claims such as sub (subject/user ID), email, name, iat (issued at), and exp (expiration).
- Used by the client to verify the user's identity.

In summary

- OAuth2 focuses on authorization (who can access what).
- OIDC adds authentication (who the user is) with ID tokens.

## Keycloak Access Token

This is a Keycloak Access Token (JWT) containing authentication and authorization details for a user.

- acr: Authentication Context Class Reference (e.g., "1" indicating the authentication level).
- aud: Audience – Specifies the intended recipient of the token (e.g., "account").
- azp: Authorized Party – The client that requested the token (example_client_id).
- exp: Expiration timestamp (Unix time) when the token will expire.
- iat: Issued At – When the token was created.
- iss: Issuer – The Keycloak server that issued the token.
- jti: Unique identifier for the token.
- sid: Session ID – Identifies the user's session.
- sub: Subject – The unique user ID in the Keycloak realm.
- typ: Type of token (e.g., "Bearer").
- scope: The scopes requested during authentication ("openid email profile"), which define what user data is included in the token.

```json
{
  "acr": "1",
  "aud": "account",
  "azp": "example_client_id",
  "email": "example@sikademo.com",
  "email_verified": true,
  "exp": 1740549195,
  "family_name": "example",
  "given_name": "example",
  "iat": 1740548895,
  "iss": "https://sso.sikalabs.com/realms/training2",
  "jti": "dc0b0a4a-45cf-49e7-bdbf-f3fb1b90f862",
  "name": "example example",
  "preferred_username": "example_username",
  "realm_access": {
    "roles": [
      "offline_access",
      "uma_authorization",
      "default-roles-training2"
    ]
  },
  "resource_access": {
    "account": {
      "roles": [
        "manage-account",
        "manage-account-links",
        "view-profile"
      ]
    }
  },
  "scope": "openid email profile",
  "sid": "24287475-0fbf-408c-b8cd-355fa245ee3c",
  "sub": "e1f6369a-16cf-4573-8a1e-bb19ee416121",
  "typ": "Bearer"
}
```

```
eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI4NUdxdnFMT01SdmtNeG4xMmdnaTJFYm1jLVRwZExCQU9tNy1yZko1NkpZIn0.eyJleHAiOjE3NDA1NDkxOTUsImlhdCI6MTc0MDU0ODg5NSwianRpIjoiZGMwYjBhNGEtNDVjZi00OWU3LWJkYmYtZjNmYjFiOTBmODYyIiwiaXNzIjoiaHR0cHM6Ly9zc28uc2lrYWxhYnMuY29tL3JlYWxtcy90cmFpbmluZzIiLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZTFmNjM2OWEtMTZjZi00NTczLThhMWUtYmIxOWVlNDE2MTIxIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiZXhhbXBsZV9jbGllbnRfaWQiLCJzaWQiOiIyNDI4NzQ3NS0wZmJmLTQwOGMtYjhjZC0zNTVmYTI0NWVlM2MiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iLCJkZWZhdWx0LXJvbGVzLXRyYWluaW5nMiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIGVtYWlsIHByb2ZpbGUiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6ImV4YW1wbGUgZXhhbXBsZSIsInByZWZlcnJlZF91c2VybmFtZSI6ImV4YW1wbGVfdXNlcm5hbWUiLCJnaXZlbl9uYW1lIjoiZXhhbXBsZSIsImZhbWlseV9uYW1lIjoiZXhhbXBsZSIsImVtYWlsIjoiZXhhbXBsZUBzaWthZGVtby5jb20ifQ.FUZasx0PAl3jFEAhjhPnM1CUAQPJbkrgilQ8ZL2VPXf-F8Uq7A0_ZMCmUUW70AMyERp76vLRbzK--nwRmgWXlxJvsK9HkOy1A_zRX_Wuq-nQSz2lU2E0VzXJsbFRVx6jcGO-4MJwO1gWpxThesOSueJRCeRcznm_ZrS-DmHscCh1TH3c85KCiHxGweETdC-VG8dDJ74wDu-rqXgIqGwXpUgjIRjrwx3TtJe6YIFx7wSis0QypiQk5fV0g59jX49REp-inDC3JMHUElSrYNsvHEKeIua3vHVfD4k9m0-5SY38BDJIpQ0bWmC3U79YB3tDxnxJKIlmzZNJRlsFN-wtOg
```

## Keycloak ID Token

The ID Token in Keycloak is a JWT (JSON Web Token) that provides identity-related claims about the authenticated user. It is primarily used by OpenID Connect (OIDC) clients to obtain user profile information.

**Purpose of the ID Token**

The ID Token is primarily meant for authentication and providing user identity information to the client application. It is not used for authorization purposes (unlike the Access Token). The client application can decode this token to retrieve user details after successful authentication.

- at_hash: A hash of the Access Token (used for validating access token integrity).
- aud: Audience – Specifies the client ID (example_client_id) for which the token is issued.
- azp: Authorized Party – The client that requested the token.
- exp: Expiration timestamp (Unix time) when the token will expire.
- iat: Issued At – The timestamp when the token was created.
- iss: Issuer – The URL of the Keycloak realm that issued the token.
- jti: Unique identifier for this token.
- sid: Session ID – Identifies the user session.
- sub: Subject – The unique user ID in the Keycloak realm.
- typ: Token type ("ID", indicating this is an ID token).

```json
{
  "acr": "1",
  "at_hash": "gib9PoLgzImfIMdhuO0UwA",
  "aud": "example_client_id",
  "azp": "example_client_id",
  "email": "example@sikademo.com",
  "email_verified": true,
  "exp": 1740550026,
  "family_name": "example",
  "given_name": "example",
  "iat": 1740549726,
  "iss": "https://sso.sikalabs.com/realms/training2",
  "jti": "b819638c-6824-45f6-a312-a62609b9d7a5",
  "name": "example example",
  "preferred_username": "example_username",
  "sid": "4310b043-a925-4e8b-a559-92400204721d",
  "sub": "e1f6369a-16cf-4573-8a1e-bb19ee416121",
  "typ": "ID"
}
```

```
eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI4NUdxdnFMT01SdmtNeG4xMmdnaTJFYm1jLVRwZExCQU9tNy1yZko1NkpZIn0.eyJleHAiOjE3NDA1NTAwMjYsImlhdCI6MTc0MDU0OTcyNiwianRpIjoiYjgxOTYzOGMtNjgyNC00NWY2LWEzMTItYTYyNjA5YjlkN2E1IiwiaXNzIjoiaHR0cHM6Ly9zc28uc2lrYWxhYnMuY29tL3JlYWxtcy90cmFpbmluZzIiLCJhdWQiOiJleGFtcGxlX2NsaWVudF9pZCIsInN1YiI6ImUxZjYzNjlhLTE2Y2YtNDU3My04YTFlLWJiMTllZTQxNjEyMSIsInR5cCI6IklEIiwiYXpwIjoiZXhhbXBsZV9jbGllbnRfaWQiLCJzaWQiOiI0MzEwYjA0My1hOTI1LTRlOGItYTU1OS05MjQwMDIwNDcyMWQiLCJhdF9oYXNoIjoiZ2liOVBvTGd6SW1mSU1kaHVPMFV3QSIsImFjciI6IjEiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6ImV4YW1wbGUgZXhhbXBsZSIsInByZWZlcnJlZF91c2VybmFtZSI6ImV4YW1wbGVfdXNlcm5hbWUiLCJnaXZlbl9uYW1lIjoiZXhhbXBsZSIsImZhbWlseV9uYW1lIjoiZXhhbXBsZSIsImVtYWlsIjoiZXhhbXBsZUBzaWthZGVtby5jb20ifQ.pCZL60D76cmMNPrOTvguVx2bxOfrn4jekP94CE_r1vgGzkbyogRBpGayp2LXkmO0mn-uC_mRNPmlTVZzl9HHJOtflWa6Xn_BDLR8bNCXnHN6TeOLY2QoVkmZ7_K1WzOPNG3fQjQ3VHuxH0roScj5mIqTuy3LHBHhBCTGfCdYB2zpuOU9sOuyyngH_hxfLmdvdbh9gRt4sOl1LeQVnOjTZVymRuFCUy9jYP99hhD_wjSsml1BglT2TXlvub3Rxc5Y-BHmxS_u96IYl6wz0w5mjv1OZ0gTjEtMGFwOamv3YEUjFZlGef8lFV9P4jSCRE7F0KNWC2gXIqDj38BgumEbow
```

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

## Install Production Keycloak to Kubernetes using Helm

```
helm upgrade --install \
  keycloak-k8s-sikademo-com \
  oci://registry-1.docker.io/bitnamicharts/keycloak \
  --version 24.4.10 \
  --namespace keycloak-k8s-sikademo-com \
  --create-namespace \
  --values examples/helm-values/keycloak-k8s-sikademo-com.yaml
```

Keycloak will be available on <https://keycloak.k8s.sikademo.com>. Admin user is `admin` and password is `admin`.

## Install Production Keycloak to Kubernetes using ArgoCD

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: keycloak-sikademo-com
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  destination:
    namespace: keycloak-sikademo-com
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
  source:
    repoURL: registry-1.docker.io/bitnamicharts
    targetRevision: 24.4.10
    chart: keycloak
    helm:
      valuesObject:
        # https://github.com/bitnami/charts/blob/main/bitnami/keycloak/values.yaml
        # https://artifacthub.io/packages/helm/bitnami/keycloak?modal=values
        replicaCount: 1
        global:
          security:
            allowInsecureImages: true
        image:
          registry: ghcr.io
          repository: sikalabs/bitnami-keycloak-sikalabs-theme
          tag: 26.1.2-debian-12-r0
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
          hostname: keycloak.sikademo.com
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

Keycloak will be available on <https://keycloak.sikademo.com>. Admin user is `admin` and password is `admin`.

## Get Keycloak Version

Go to https://keycloak.sikademo.com/admin/master/console/#/master/info

## Keycloak Terraform Configuration

```terraform
terraform {
  required_providers {
    keycloak = {
      source = "keycloak/keycloak"
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

## Optional Client Scopes

Must be requested by the client

```terraform
resource "keycloak_openid_client_optional_scopes" "example" {
  realm_id  = keycloak_realm.example.id
  client_id = keycloak_openid_client.example.id

  optional_scopes = [
    keycloak_openid_client_scope.example_groups.name,
  ]
}
```

## Install Node.js

Setup NVM

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
echo '. ~/.nvm/nvm.sh' >> ~/.zshrc
echo '. ~/.nvm/nvm.sh' >> ~/.bashrc
. ~/.nvm/nvm.sh
```

Install Node 22

```sh
nvm install 22
```

Use Node 22

```sh
nvm use 22
```

## Express.js example without any Keycloak Library

[examples/express_api_simple](./examples/express_api_simple)

```sh
cd examples/express_api_simple
npm install
cp .env.dist .env
```

```sh
vim .env
```

```sh
npm start
```

## Flows

In Keycloak, flows are authentication processes that define how users authenticate and interact with Keycloak during login, registration, and other identity-related actions. These flows are highly customizable and consist of multiple execution steps, allowing for complex authentication and authorization scenarios.

### Types of Flows in Keycloak

- Browser Flow – Handles web-based authentication, such as logging in through a browser.
- Direct Grant Flow – Used for authentication via API (e.g., OAuth 2.0 password grant).
- Registration Flow – Defines how user registration is handled.
- Reset Credentials Flow – Manages the process of resetting user credentials (e.g., forgotten passwords).
- Client Authentication Flow – Used for authenticating clients (applications) to Keycloak.
- First Broker Login Flow – Manages authentication when users log in using an external identity provider (e.g., Google, GitHub, LDAP).
- User-initiated Action Flow – Defines actions users can take after login, like updating passwords.

### Flow Structure

Each flow consists of authentication executions, which are steps in the flow. These executions can be

- Required – Must be executed for authentication to proceed.
- Alternative – Can be skipped if another option is available.
- Disabled – Not executed.
- Conditional – Executed only if certain conditions are met.

### Flow Customization

You can modify existing flows or create new ones under Authentication > Flows in the Keycloak Admin Console. This allows you to:

- Add or remove authentication steps.
- Enforce MFA (Multi-Factor Authentication).
- Integrate external identity providers.

### Example of IDP Only Browser Flow

```terraform
resource "keycloak_authentication_flow" "idp_only_browser_flow" {
  realm_id = keycloak_realm.example2.id
  alias    = "idp_only_browser_flow"
}

resource "keycloak_authentication_execution" "idp_only_browser_flow_01" {
  realm_id          = keycloak_realm.example2.id
  parent_flow_alias = keycloak_authentication_flow.idp_only_browser_flow.alias
  authenticator     = "identity-provider-redirector"
  requirement       = "REQUIRED"
}

resource "keycloak_authentication_execution_config" "idp_only_browser_flow_01" {
  realm_id     = keycloak_realm.example2.id
  execution_id = keycloak_authentication_execution.idp_only_browser_flow_01.id
  alias        = "identity-provider-redirector"
  config = {
    defaultProvider = keycloak_oidc_identity_provider.example2.id
  }
}

resource "keycloak_authentication_bindings" "browser_authentication_binding" {
  realm_id     = keycloak_realm.example2.id
  browser_flow = keycloak_authentication_flow.idp_only_browser_flow.alias
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

## Training Sessions

#### 2025-02-26 Ataccama

- https://github.com/sika-training-examples/2025-02-26_keycloak-ataccama-example (in training example repo)
- https://github.com/sika-training-examples/2025-02-27_keycloak-mapping-example (better example of atrribute mapping and user federation)

#### 2025-02-10

- Keycloak Terraform Example - https://github.com/sika-training-examples/2025-02-10_keycloak-terraform-example
