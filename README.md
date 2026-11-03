[Ondrej Sika (sika.io)](https://sika.io) | <ondrej@sika.io> | [**Skoleni Keycloak**](https://ondrej-sika.cz/skoleni/keycloak/) 🚀💻

# Keycloak Training

## Related Repositories

- https://github.com/ondrejsika/nextjs-auth-minimal-example

## Course

## About Me: [Ondrej Sika](https://sika.io)

__Freelance DevOps Engineer, Consultant & Lecturer__

- Complete DevOps Pipeline
- Open Source / Linux Stack
- Cloud & On-Premise
- Technologies: Git, Gitlab, Gitlab CI, Docker, Kubernetes, Terraform, Prometheus, ELK / EFK, Rancher, Proxmox, DigitalOcean, AWS

## Star, Create Issues, Fork, and Contribute

Feel free to star this repository or fork it.

If you find a bug, create an issue or pull request.

Also feel free to propose improvements by creating issues.

## Chat

For sharing links & "secrets".

- Zoom Chat
- Slack - https://sikapublic.slack.com/
- Microsoft Teams
- https://sika.link/chat (tlk.io)

<!--

## DevOps Kniha (Czech only)

[![](./images/devops_kniha.jpg)](https://kniha.sika.io)

<https://kniha.sika.io>

-->

## What is Keycloak

Keycloak is an open-source identity and access management (IAM) solution developed by Red Hat. It provides authentication and authorization services for applications and services.

## Key Features of Keycloak

- Single Sign-On (SSO): Users can log in once and access multiple applications without re-authenticating.
- Identity Brokering: Supports authentication via third-party identity providers like Google, Microsoft, GitHub, or any OIDC/SAML provider.
- User Federation: Integrates with existing user directories (LDAP, Active Directory).
- Multi-Factor Authentication (MFA): Supports OTP, WebAuthn, and other MFA mechanisms.
- Fine-Grained Authorization: Offers Role-Based Access Control (RBAC) and Attribute-Based Access Control (ABAC), see [Authorization Services](#authorization-services).
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

OAuth 2.0 and OpenID Connect (OIDC) are related but serve different purposes.

### OAuth 2.0

- Purpose: Authorization framework.
- What it does: Allows users to grant third-party applications access to their resources without sharing credentials.
- Example Use Case: A scheduling app asks for permission to read your Google Calendar. You approve the consent screen and the app gets an access token for the Calendar API, without ever getting your Google password (and without learning who you are, which is what OIDC adds).
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

JSON Web Token (JWT) is an open standard (RFC 7519) that defines a compact, URL-safe, and self-contained way for securely transmitting information between parties as a JSON object. This information can be verified and trusted because it is digitally signed.

It is commonly used for authentication and authorization in web applications.

### Structure of JWT

A JWT consists of three parts, separated by dots (`.`):

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
- Sent in API requests (e.g., `Authorization: Bearer <token>`).
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

In summary:

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
cd examples/docker_compose
```

Set `HOST` to the domain where Keycloak will be available. Caddy gets a Let's Encrypt certificate for it, so the domain must point to the server and ports 80 and 443 must be reachable from the internet.

```sh
HOST=keycloak.docker.sikademo.com docker compose up -d
```

For a local try, use `HOST=localhost`. Caddy then issues a certificate from its own internal CA, which the browser will not trust (accept the warning).

```sh
HOST=localhost docker compose up -d
```

Keycloak will be available on `https://$HOST`. Admin user is `admin` and password is `admin`.

## Install Production Keycloak to Kubernetes

TODO

## Install Production Keycloak to Kubernetes using ArgoCD

TODO

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

Go to <https://keycloak.sikademo.com> and login as `admin` with password `admin`. Click on `Create realm` button and fill the form.

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

You can add user here <https://keycloak.sikademo.com/admin/master/console/#/example/users>

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

Roles and groups have a similar purpose, which is to give users access and permissions to use applications. Groups are a collection of users to which you apply roles and attributes. Roles define application-specific permissions and access control.

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

Groups are a collection of users to which you apply roles and attributes. Roles define application-specific permissions and access control.

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

```terraform
resource "keycloak_user_roles" "ondrej" {
  realm_id = keycloak_realm.example.id
  user_id  = keycloak_user.ondrej.id

  role_ids = [
    keycloak_role.editor.id,
  ]
}
```

### Assign Role to Group

```terraform
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

Direct Access Grants is Keycloak's name for the OAuth 2.0 Resource Owner Password Credentials (ROPC) grant (`grant_type=password`): the client sends the user's username and password straight to the token endpoint. The client needs "Direct access grants" enabled.

> **Note:** ROPC is deprecated (OAuth 2.0 Security Best Current Practice) and removed in OAuth 2.1. The app sees the user's password, and the grant bypasses the login page, so MFA, identity providers and required actions don't apply. Use it only for testing and scripts like these, and use the Authorization Code flow (with PKCE) in real apps.

Plain OAuth 2.0 request, returns `access_token` and `refresh_token` only:

```sh
curl -X POST "https://keycloak.sikademo.com/realms/test/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=default" \
  -d "client_secret=default" \
  -d "grant_type=password" \
  -d "username=user" \
  -d "password=a"
```

With `scope=openid` the request becomes an OpenID Connect request, so the response also contains an `id_token` (a JWT with the user's identity). Without `openid`, Keycloak returns no ID token and the UserInfo endpoint rejects the access token.

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

Confidential client (server-side app that can keep a secret):

```terraform
resource "keycloak_openid_client" "example_backend" {
  realm_id                        = keycloak_realm.example.id
  client_id                       = "example_backend"
  client_secret                   = "example" # demo only, keep real secrets out of Git
  enabled                         = true
  access_type                     = "CONFIDENTIAL"
  standard_flow_enabled           = true
  valid_redirect_uris             = ["*"]
  valid_post_logout_redirect_uris = ["*"]
  web_origins                     = ["*"]
}
```

Public client (SPA or mobile app). It runs on the user's device and cannot keep a secret, so it has no `client_secret` and uses PKCE instead:

```terraform
resource "keycloak_openid_client" "example" {
  realm_id                        = keycloak_realm.example.id
  client_id                       = "example"
  enabled                         = true
  access_type                     = "PUBLIC"
  standard_flow_enabled           = true
  pkce_code_challenge_method      = "S256"
  valid_redirect_uris             = ["*"]
  valid_post_logout_redirect_uris = ["*"]
  web_origins                     = ["*"]
}
```

> **Security:** These examples use `"*"` to keep the demo simple. Never use `valid_redirect_uris = ["*"]` (or `web_origins = ["*"]`) outside of a local demo. Keycloak sends the authorization code to the redirect URI, so a wildcard lets an attacker craft a login link that delivers the user's code (and with it their tokens) to a site they control (open redirect). Always list the exact URIs of your app, and use a trailing `/*` only within your own host.

## OAuth 2.0 Flows (Grant Types)

A flow (grant type) is the way a client gets tokens from Keycloak. Which one to use depends on who the client is acting for and where it runs:

| Flow | Use case | Client type | User present |
| --- | --- | --- | --- |
| Authorization Code + PKCE | Web apps, SPAs, mobile apps | Public or Confidential | Yes, in the browser |
| Client Credentials | Service-to-service, cron jobs, backends | Confidential | No |
| Device Authorization | TVs, CLIs, devices without a browser | Public or Confidential | Yes, on another device |
| Token Exchange | Service calls another service on behalf of the user | Confidential | No (uses an existing token) |
| Refresh Token | Get a new access token without logging in again | Any | No |
| ~~Password (ROPC)~~ | Testing only, see [Test Direct Access Grants](#test-direct-access-grants) | | |
| ~~Implicit~~ | Deprecated, don't use (tokens in the URL) | | |

Examples below use the `example` realm. All endpoints are listed in the discovery document:

```sh
curl -s https://keycloak.sikademo.com/realms/example/.well-known/openid-configuration | jq
```

### Authorization Code Flow with PKCE

The recommended flow for any app with a user. The user logs in on Keycloak's login page (so MFA, identity providers and required actions all work), and the app only receives a short-lived one-time **authorization code** in the redirect, which it exchanges for tokens over a back channel.

**PKCE** (Proof Key for Code Exchange, RFC 7636) protects the code: the app generates a random `code_verifier`, sends its SHA-256 hash (`code_challenge`) in the login request, and must send the original `code_verifier` when exchanging the code. An attacker who steals the code from the redirect can't use it without the verifier. PKCE is required for public clients and recommended for confidential clients too (mandatory in OAuth 2.1).

<!--

```mermaid
sequenceDiagram
    autonumber
    actor User
    participant Browser
    participant App as App (client)
    participant KC as Keycloak
    participant API as API (resource server)

    User->>Browser: Click "Login"
    Browser->>App: GET /login
    App->>App: Generate state, code_verifier,<br/>code_challenge = SHA256(code_verifier)
    App-->>Browser: 302 to Keycloak /auth?response_type=code<br/>&client_id&redirect_uri&scope=openid<br/>&state&code_challenge&code_challenge_method=S256
    Browser->>KC: GET /auth?...
    KC-->>Browser: Login page
    User->>Browser: Username, password (+ MFA)
    Browser->>KC: POST credentials
    KC->>KC: Authenticate user, store code_challenge
    KC-->>Browser: 302 to redirect_uri?code=...&state=...
    Browser->>App: GET /callback?code=...&state=...
    App->>App: Check state
    App->>KC: POST /token grant_type=authorization_code<br/>&code&redirect_uri&code_verifier<br/>(+ client_secret if confidential)
    KC->>KC: Check SHA256(code_verifier) == code_challenge
    KC-->>App: access_token, id_token, refresh_token
    App->>API: GET /resource<br/>Authorization: Bearer access_token
    API-->>App: Protected data
```

-->

Try it manually with the public `example` client. Generate the PKCE pair:

```sh
CODE_VERIFIER=$(openssl rand -base64 60 | tr -d '\n=+/' | cut -c1-64)
CODE_CHALLENGE=$(printf %s "$CODE_VERIFIER" | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '=')
```

Open the login URL in the browser:

```sh
echo "https://keycloak.sikademo.com/realms/example/protocol/openid-connect/auth?response_type=code&client_id=example&redirect_uri=http://localhost:8000/callback&scope=openid&state=xyz&code_challenge=$CODE_CHALLENGE&code_challenge_method=S256"
```

After login, the browser is redirected to `http://localhost:8000/callback?state=xyz&code=...` (the page doesn't need to load). Copy the `code` and exchange it for tokens, within 1 minute (default code lifespan):

```sh
curl -X POST "https://keycloak.sikademo.com/realms/example/protocol/openid-connect/token" \
  -d "grant_type=authorization_code" \
  -d "client_id=example" \
  -d "redirect_uri=http://localhost:8000/callback" \
  -d "code_verifier=$CODE_VERIFIER" \
  -d "code=<code>"
```

To require PKCE on a client, set Advanced > "Proof Key for Code Exchange Code Challenge Method" to `S256` (`pkce_code_challenge_method = "S256"` in Terraform).

### Client Credentials Flow (Service Accounts)

For machine-to-machine communication with no user involved. The client authenticates with its own `client_id` and `client_secret` and gets an access token for itself.

In Keycloak, every client with Client Credentials enabled gets a **service account**, a special user named `service-account-<client_id>`. Roles are assigned to it in the client's "Service accounts roles" tab, and they end up in its access token like for a normal user.

Enable it on a confidential client: Capability config > Client authentication ON, Authentication flow > "Service accounts roles". In Terraform:

```terraform
resource "keycloak_openid_client" "example_service" {
  realm_id                 = keycloak_realm.example.id
  client_id                = "example_service"
  client_secret            = "example" # demo only, keep real secrets out of Git
  access_type              = "CONFIDENTIAL"
  service_accounts_enabled = true
}

resource "keycloak_openid_client_service_account_realm_role" "example_service_admin" {
  realm_id                = keycloak_realm.example.id
  service_account_user_id = keycloak_openid_client.example_service.service_account_user_id
  role                    = "admin"
}
```

Get a token:

```sh
curl -X POST "https://keycloak.sikademo.com/realms/example/protocol/openid-connect/token" \
  -d "grant_type=client_credentials" \
  -d "client_id=example_service" \
  -d "client_secret=example"
```

The response has only an `access_token`, without a refresh token (the client can always ask for a new one with its secret) and without an ID token (there is no user to identify).

### Device Authorization Grant

For devices that can't show a login page or don't have a keyboard: smart TVs, CLIs, IoT (RFC 8628). The device shows a short code, and the user logs in on their phone or computer. Used for example by `gh auth login` or `az login --use-device-code`.

Enable it on the client: Capability config > "OAuth 2.0 Device Authorization Grant" (`oauth2_device_authorization_grant_enabled = true` in Terraform).

1. The device asks for a device code:

```sh
curl -X POST "https://keycloak.sikademo.com/realms/example/protocol/openid-connect/auth/device" \
  -d "client_id=example" \
  -d "scope=openid"
```

```json
{
  "device_code": "Q2l...",
  "user_code": "ABCD-EFGH",
  "verification_uri": "https://keycloak.sikademo.com/realms/example/device",
  "verification_uri_complete": "https://keycloak.sikademo.com/realms/example/device?user_code=ABCD-EFGH",
  "expires_in": 600,
  "interval": 5
}
```

2. The device shows `user_code` and `verification_uri` (often as a QR code of `verification_uri_complete`). The user opens it on another device, enters the code, logs in and approves.

3. Meanwhile the device polls the token endpoint every `interval` seconds:

```sh
curl -X POST "https://keycloak.sikademo.com/realms/example/protocol/openid-connect/token" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:device_code" \
  -d "client_id=example" \
  -d "device_code=<device_code>"
```

Until the user finishes, Keycloak returns `authorization_pending` (or `slow_down` if polling too fast). After approval, it returns the tokens.

### Token Exchange

Token Exchange (RFC 8693) trades one token for another. Typical use: a frontend calls service A with the user's token, and service A needs to call service B **as the same user**. Instead of forwarding its own token (which has the wrong audience and maybe too many permissions), service A exchanges it for a new token for service B.

Since Keycloak 26.2, **Standard Token Exchange** (V2) is fully supported (GA) and doesn't need any feature flag. Enable it on the requesting client (service A, must be confidential): Capability config > "Standard Token Exchange".

```sh
curl -X POST "https://keycloak.sikademo.com/realms/example/protocol/openid-connect/token" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:token-exchange" \
  -d "client_id=service-a" \
  -d "client_secret=example" \
  -d "subject_token=<user's access token>" \
  -d "subject_token_type=urn:ietf:params:oauth:token-type:access_token" \
  -d "audience=service-b"
```

Rules for standard token exchange:

- The subject token must have the requesting client in its `aud` claim (add an Audience mapper to the frontend's client scope), so a client can only exchange tokens that were meant for it.
- `audience` and `scope` can only narrow down the new token (downscoping), never add permissions the user doesn't have.
- It returns an access token by default. A refresh token can be requested with `requested_token_type=urn:ietf:params:oauth:token-type:refresh_token`, if the client allows it.
- Only internal-to-internal exchange (Keycloak token for Keycloak token). Exchanging external IdP tokens and impersonation are still only in the legacy Token Exchange V1, which is a preview feature (`--features=token-exchange`).

### Refresh Tokens

Access tokens are short-lived (5 minutes by default in Keycloak). When one expires, the client uses the refresh token to get a new one, without the user logging in again:

```sh
curl -X POST "https://keycloak.sikademo.com/realms/example/protocol/openid-connect/token" \
  -d "grant_type=refresh_token" \
  -d "client_id=example" \
  -d "refresh_token=<refresh_token>"
```

- A refresh token is tied to the user's SSO session. It stops working when the session ends: on logout, after SSO Session Idle (30 minutes without activity by default) or SSO Session Max (10 hours by default). Settings are in Realm settings > Sessions and Tokens.
- When the user logs out or an admin ends the session, all its refresh tokens are invalidated.
- Refresh token rotation (Realm settings > Tokens > "Revoke Refresh Token") makes each refresh token single use, which helps detect stolen tokens. It's off by default.

### Offline Tokens

An offline token is a refresh token that is **not** tied to the SSO session. It keeps working after the user logs out of the browser, closes it, or Keycloak restarts, because offline sessions are stored in the database. Use it when an app needs to act for the user while they are away, e.g. nightly sync jobs or mobile apps that should stay logged in for weeks.

Request it by adding the `offline_access` scope to the login request (the user needs the `offline_access` realm role, which is in the default roles). Run the [Authorization Code flow](#authorization-code-flow-with-pkce) with this login URL, and exchange the code the same way:

```sh
echo "https://keycloak.sikademo.com/realms/example/protocol/openid-connect/auth?response_type=code&client_id=example&redirect_uri=http://localhost:8000/callback&scope=openid%20offline_access&state=xyz&code_challenge=$CODE_CHALLENGE&code_challenge_method=S256"
```

The `refresh_token` in the response is now an offline token.

- The decoded refresh token has `"typ": "Offline"` instead of `"typ": "Refresh"`.
- It expires after Offline Session Idle (30 days without use by default). Offline Session Max is disabled by default, so an offline token used regularly never expires.
- Store it securely, it's a long-lived credential. Users can revoke it in the Account Console (Applications), admins in the user's Consents tab or Sessions.

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

Must be requested by the client.

```terraform
resource "keycloak_openid_client_optional_scopes" "example" {
  realm_id  = keycloak_realm.example.id
  client_id = keycloak_openid_client.example.id

  optional_scopes = [
    keycloak_openid_client_scope.example_groups.name,
  ]
}
```

## Authorization Services

Roles and groups in the token (RBAC) are enough for most apps: the app reads `realm_access.roles` and decides itself. Keycloak Authorization Services go further: the app asks **Keycloak** "can this user do X with resource Y?", and Keycloak decides based on central policies. This is how Keycloak supports fine-grained authorization, including ABAC (decisions based on user attributes, time, client, ...) and UMA (users sharing their own resources).

Use it when authorization rules change often, are shared by several services, or must be managed by admins without redeploying apps. It adds complexity and an extra call to Keycloak, so start with RBAC if that is enough.

### Concepts

Authorization Services are enabled per client. That client is the **resource server** (the API being protected), and has these parts (Client > Authorization tab):

- **Resource** – what is protected: an object or a group of objects, e.g. `documents` with URI `/documents/*`. A resource can have a type, an owner and attributes.
- **Scope** – what can be done with a resource, e.g. `view`, `edit`, `delete`.
- **Policy** – a condition that is true or false, independent of any resource, e.g. "user has role `editor`", "user is in group `team-a`", "it's a working day". Policies can be combined (aggregated policy).
- **Permission** – connects resources and/or scopes with policies: "to `edit` `documents`, policies X and Y must be true". A permission is either resource-based (the whole resource) or scope-based (one action on it).

Built-in policy types:

- Role, Group, User, Client, Client Scope – RBAC style, who the user is or which app is calling.
- Time – allow only in a time window (e.g. office hours).
- Regex – match a claim of the token (e.g. `email` ending with `@example.com`), a simple ABAC.
- Aggregated – combines other policies.
- JavaScript – custom logic. For security reasons it can't be written in the Admin Console, it must be [deployed as a JAR](https://www.keycloak.org/docs/latest/server_development/#_script_providers).

Each permission (and aggregated policy) has a **decision strategy**:

- Unanimous – all policies must be true (AND).
- Affirmative – at least one policy must be true (OR).
- Consensus – more true than false.

### Enable Authorization Services

Client > Capability config > Client authentication **ON** and Authorization **ON**. The client must be confidential.

In Client > Authorization > Settings, the **Policy enforcement mode**:

- Enforcing (default) – requests are denied if no policy grants access, also for resources without any permission.
- Permissive – requests are allowed when a resource has no permissions.
- Disabled – no evaluation, everything is allowed.

Use Client > Authorization > **Evaluate** to test which permissions a given user gets, without writing any code.

### Example: Documents API

Users with the `viewer` or `editor` role can view documents. Only `editor`s in the group `team-a` can edit them (roles and group from [Roles](#roles) and [Groups](#groups)).

```terraform
resource "keycloak_openid_client" "documents_api" {
  realm_id                 = keycloak_realm.example.id
  client_id                = "documents_api"
  client_secret            = "example" # demo only, keep real secrets out of Git
  access_type              = "CONFIDENTIAL"
  service_accounts_enabled = true # required for Authorization Services

  authorization {
    policy_enforcement_mode = "ENFORCING"
    decision_strategy       = "UNANIMOUS"
  }
}

# Scopes: what can be done with a resource
resource "keycloak_openid_client_authorization_scope" "view" {
  realm_id           = keycloak_realm.example.id
  resource_server_id = keycloak_openid_client.documents_api.resource_server_id
  name               = "view"
}

resource "keycloak_openid_client_authorization_scope" "edit" {
  realm_id           = keycloak_realm.example.id
  resource_server_id = keycloak_openid_client.documents_api.resource_server_id
  name               = "edit"
}

# Resource: what is protected
resource "keycloak_openid_client_authorization_resource" "documents" {
  realm_id           = keycloak_realm.example.id
  resource_server_id = keycloak_openid_client.documents_api.resource_server_id
  name               = "documents"
  type               = "urn:documents_api:resources:document"
  uris               = ["/documents/*"]
  scopes = [
    keycloak_openid_client_authorization_scope.view.name,
    keycloak_openid_client_authorization_scope.edit.name,
  ]
}

# Policies: who (conditions, no resources here)
resource "keycloak_openid_client_role_policy" "is_viewer" {
  realm_id           = keycloak_realm.example.id
  resource_server_id = keycloak_openid_client.documents_api.resource_server_id
  name               = "is_viewer"
  type               = "role"
  logic              = "POSITIVE"
  decision_strategy  = "UNANIMOUS"
  role {
    id       = keycloak_role.viewer.id
    required = true
  }
}

resource "keycloak_openid_client_role_policy" "is_editor" {
  realm_id           = keycloak_realm.example.id
  resource_server_id = keycloak_openid_client.documents_api.resource_server_id
  name               = "is_editor"
  type               = "role"
  logic              = "POSITIVE"
  decision_strategy  = "UNANIMOUS"
  role {
    id       = keycloak_role.editor.id
    required = true
  }
}

resource "keycloak_openid_client_group_policy" "in_team_a" {
  realm_id           = keycloak_realm.example.id
  resource_server_id = keycloak_openid_client.documents_api.resource_server_id
  name               = "in_team_a"
  logic              = "POSITIVE"
  decision_strategy  = "UNANIMOUS"
  groups {
    id              = keycloak_group.team-a.id
    path            = keycloak_group.team-a.path
    extend_children = false
  }
}

# Permissions: connect resources/scopes with policies
resource "keycloak_openid_client_authorization_permission" "view_documents" {
  realm_id           = keycloak_realm.example.id
  resource_server_id = keycloak_openid_client.documents_api.resource_server_id
  name               = "view_documents"
  type               = "scope"
  resources          = [keycloak_openid_client_authorization_resource.documents.id]
  scopes             = [keycloak_openid_client_authorization_scope.view.id]
  decision_strategy  = "AFFIRMATIVE" # viewer OR editor
  policies = [
    keycloak_openid_client_role_policy.is_viewer.id,
    keycloak_openid_client_role_policy.is_editor.id,
  ]
}

resource "keycloak_openid_client_authorization_permission" "edit_documents" {
  realm_id           = keycloak_realm.example.id
  resource_server_id = keycloak_openid_client.documents_api.resource_server_id
  name               = "edit_documents"
  type               = "scope"
  resources          = [keycloak_openid_client_authorization_resource.documents.id]
  scopes             = [keycloak_openid_client_authorization_scope.edit.id]
  decision_strategy  = "UNANIMOUS" # editor AND member of team-a
  policies = [
    keycloak_openid_client_role_policy.is_editor.id,
    keycloak_openid_client_group_policy.in_team_a.id,
  ]
}
```

### Ask Keycloak for a Decision

The client gets the user's access token as usual (e.g. with the [Authorization Code flow](#authorization-code-flow-with-pkce)), then asks the token endpoint about permissions with the UMA grant type. `audience` is the resource server's `client_id`, and `permission` is `resource#scope`:

```sh
curl -X POST "https://keycloak.sikademo.com/realms/example/protocol/openid-connect/token" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:uma-ticket" \
  -d "audience=documents_api" \
  -d "permission=documents#edit" \
  -d "response_mode=decision"
```

`response_mode` controls the answer:

- `decision` – just `{"result": true}`, or `403` with `access_denied`. Good for a simple yes/no check in the API.
- `permissions` – the list of granted resources and scopes, e.g. `[{"rsname": "documents", "scopes": ["view"]}]`. Good for showing or hiding buttons in the UI.
- (not set) – a **Requesting Party Token (RPT)**: a new access token with the granted permissions in the `authorization.permissions` claim. The client sends the RPT to the API, and the API checks the claim without calling Keycloak again.

Without `permission`, Keycloak evaluates all resources the user can access.

Policy enforcer libraries do this for you: `keycloak-policy-enforcer` for Java (Quarkus has it built in with `quarkus-keycloak-authorization`). For other languages, call the token endpoint as above.

### UMA (User-Managed Access)

UMA 2.0 lets **users** manage access to their own resources, like sharing a document in Google Drive. The user (resource owner) decides who can access the resource, instead of only admins writing policies.

1. Enable it in Realm settings > General > **User-managed access** ON.
2. The resource server registers a resource for each user's object, with the user as `owner` and **User-Managed Access Enabled** (`ownerManagedAccess`). Apps do this at runtime with the Protection API (`/realms/example/authz/protection/resource_set`), using a token of the resource server's service account (Protection API Token, PAT).
3. The owner shares the resource with other users in the Account Console (**Resources**), and picks which scopes they get (e.g. only `view`).
4. When another user tries to access a resource they don't have permission for, the API answers `401` with a **permission ticket** (`WWW-Authenticate: UMA realm="example", as_uri="...", ticket="..."`). The client sends the ticket to the token endpoint (`grant_type=urn:ietf:params:oauth:grant-type:uma-ticket&ticket=...`) and gets an RPT if access is granted. If not, Keycloak can create a **permission request**, and the owner sees it in the Account Console and can approve or deny it.

## Install Node.js

Setup NVM

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
echo '. ~/.nvm/nvm.sh' >> ~/.zshrc
echo '. ~/.nvm/nvm.sh' >> ~/.bashrc
. ~/.nvm/nvm.sh
```

Install Node 26 (active LTS)

```sh
nvm install 26
```

Use Node 26

```sh
nvm use 26
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
- First Broker Login Flow – Runs the first time a user logs in through an external identity provider (e.g., Google, GitHub, another OIDC/SAML IdP), to create or link the Keycloak account. (LDAP is User Federation, not an identity provider, so this flow is not used for it.)
- Docker Authentication Flow – Used for authenticating to a Docker registry with Keycloak as its auth server.

### Required Actions

Required Actions are not a flow, they are a separate concept (Authentication > Required actions). A required action is a step the user must complete before they can finish logging in, e.g. Update Password, Configure OTP, Verify Email, Update Profile or Terms and Conditions. They can be set on a user by an admin, set by default for new users, or triggered by Keycloak itself (e.g. expired password).

Application Initiated Actions (AIA) are another feature built on top of required actions: the application asks Keycloak to run one action, for example by adding `kc_action=UPDATE_PASSWORD` to the authorization request. The user completes it and is redirected back to the application.

### Flow Structure

Each flow consists of authentication executions, which are steps in the flow. These executions can be:

- Required – Must be executed for authentication to proceed.
- Alternative – Can be skipped if another option is available.
- Disabled – Not executed.
- Conditional – Executed only if certain conditions are met.

### Flow Customization

You can modify existing flows or create new ones under Authentication > Flows in the Keycloak Admin Console. This allows you to:

- Add or remove authentication steps.
- Enforce MFA (Multi-Factor Authentication).
- Integrate external identity providers.

### Conditional Flows

A sub-flow with requirement **Conditional** runs only if all the conditions inside it are true. Conditions are special executions (`Condition - ...`) at the top of the sub-flow. If any of them is false, the whole sub-flow is skipped. This lets you build flows like "ask for OTP only for admins" or "ask for a second factor only when the app needs it".

The built-in `browser` flow already uses one:

```
browser
├── Cookie                                   ALTERNATIVE
├── Identity Provider Redirector             ALTERNATIVE
└── forms                                    ALTERNATIVE
    ├── Username Password Form               REQUIRED
    └── Browser - Conditional OTP            CONDITIONAL
        ├── Condition - user configured      REQUIRED
        └── OTP Form                         REQUIRED
```

`Condition - user configured` is true when the user has set up the authenticators in the sub-flow (here an OTP). So users with OTP are asked for it, and users without it are not.

Available conditions:

- Condition - user configured – the user has credentials for the executions in the sub-flow.
- Condition - user role – the user has a given role (`negate` inverts it).
- Condition - user attribute – a user attribute has a given value.
- Condition - client scope – the client requested a given client scope.
- Condition - sub-flow executed – another sub-flow did (or didn't) run.
- Condition - Level of Authentication – used for step-up authentication. The client asks for a level with `acr_values` (e.g. `acr_values=gold`), and only the sub-flows up to that level run. Realm settings > General > ACR to LoA Mapping maps `acr` values to levels.

Built-in flows can't be edited directly. Duplicate one (Authentication > Flows > ⋮ > Duplicate), change the copy, and bind it (⋮ > Bind flow) as the realm's browser flow, or override it on a single client (Client > Advanced > Authentication flow overrides).

### Example of Browser Flow with OTP only for Admins

Users with the `admin` realm role must use OTP. If they don't have it yet, Keycloak asks them to set it up at login. Other users log in with a password only.

```terraform
resource "keycloak_authentication_flow" "browser_admin_otp" {
  realm_id = keycloak_realm.example.id
  alias    = "browser_admin_otp"
}

resource "keycloak_authentication_execution" "browser_admin_otp_cookie" {
  realm_id          = keycloak_realm.example.id
  parent_flow_alias = keycloak_authentication_flow.browser_admin_otp.alias
  authenticator     = "auth-cookie"
  requirement       = "ALTERNATIVE"
}

resource "keycloak_authentication_subflow" "browser_admin_otp_forms" {
  realm_id          = keycloak_realm.example.id
  parent_flow_alias = keycloak_authentication_flow.browser_admin_otp.alias
  alias             = "browser_admin_otp_forms"
  provider_id       = "basic-flow"
  requirement       = "ALTERNATIVE"
  depends_on        = [keycloak_authentication_execution.browser_admin_otp_cookie]
}

resource "keycloak_authentication_execution" "browser_admin_otp_password" {
  realm_id          = keycloak_realm.example.id
  parent_flow_alias = keycloak_authentication_subflow.browser_admin_otp_forms.alias
  authenticator     = "auth-username-password-form"
  requirement       = "REQUIRED"
}

resource "keycloak_authentication_subflow" "browser_admin_otp_conditional" {
  realm_id          = keycloak_realm.example.id
  parent_flow_alias = keycloak_authentication_subflow.browser_admin_otp_forms.alias
  alias             = "browser_admin_otp_conditional"
  provider_id       = "basic-flow"
  requirement       = "CONDITIONAL"
  depends_on        = [keycloak_authentication_execution.browser_admin_otp_password]
}

resource "keycloak_authentication_execution" "browser_admin_otp_condition" {
  realm_id          = keycloak_realm.example.id
  parent_flow_alias = keycloak_authentication_subflow.browser_admin_otp_conditional.alias
  authenticator     = "conditional-user-role"
  requirement       = "REQUIRED"
}

resource "keycloak_authentication_execution_config" "browser_admin_otp_condition" {
  realm_id     = keycloak_realm.example.id
  execution_id = keycloak_authentication_execution.browser_admin_otp_condition.id
  alias        = "browser_admin_otp_condition"
  config = {
    condUserRole = "admin"
    negate       = "false"
  }
}

resource "keycloak_authentication_execution" "browser_admin_otp_otp" {
  realm_id          = keycloak_realm.example.id
  parent_flow_alias = keycloak_authentication_subflow.browser_admin_otp_conditional.alias
  authenticator     = "auth-otp-form"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.browser_admin_otp_condition]
}

resource "keycloak_authentication_bindings" "browser_admin_otp" {
  realm_id     = keycloak_realm.example.id
  browser_flow = keycloak_authentication_flow.browser_admin_otp.alias
}
```

Executions are ordered by creation, so `depends_on` keeps them in the right order.

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

## Multi-Factor Authentication (MFA)

MFA asks the user for more than one factor: something they know (password), something they have (phone, security key) or something they are (fingerprint, face). Keycloak supports OTP and WebAuthn (security keys and passkeys) out of the box.

How MFA is enforced is controlled by [flows](#flows) and [required actions](#required-actions):

- The flow decides **when** a factor is asked for (always, only for some users, only for some apps, see [Conditional Flows](#conditional-flows)).
- The required action (e.g. Configure OTP) makes the user **set up** the factor at the next login. Set it on a user (Users > user > Required user actions), or for all new users (Authentication > Required actions > "Set as default action").

### OTP (One-Time Password)

A 6-digit code from an authenticator app like Google Authenticator, Microsoft Authenticator, FreeOTP or 1Password. The user scans a QR code once, and the app then generates a new code every 30 seconds (TOTP) from a shared secret.

- OTP is already part of the built-in browser flow (`Browser - Conditional OTP`): users who have set up OTP are asked for a code.
- To make a user set up OTP, add the **Configure OTP** required action to them. The user can also set it up themselves in the Account Console (Account security > Signing in).
- To require OTP for everyone, set `OTP Form` in the browser flow to Required (in a copy of the flow), or make Configure OTP a default action.
- Settings (TOTP/HOTP, algorithm, digits, period) are in Authentication > Policies > OTP Policy. Keep the defaults (TOTP, SHA1, 6 digits, 30 s), most apps support only those.

```terraform
resource "keycloak_realm" "example" {
  # ...
  otp_policy {
    type      = "totp"
    algorithm = "HmacSHA1"
    digits    = 6
    period    = 30
  }
}
```

OTP is phishable: a fake login page can ask for the code and use it right away. WebAuthn and passkeys are not.

### WebAuthn (Security Keys)

WebAuthn (part of FIDO2) uses public-key cryptography with a hardware or platform authenticator: a security key (YubiKey), Touch ID, Face ID or Windows Hello. The private key never leaves the device, and the browser binds each credential to the site's domain, so it **can't be phished**.

As a second factor, after the password:

1. Set up the policy in Authentication > Policies > Webauthn Policy (the defaults are fine for a start, Relying Party ID defaults to the Keycloak hostname).
2. In a copy of the browser flow, add the `WebAuthn Authenticator` execution to the conditional sub-flow (next to or instead of `OTP Form`).
3. Users register their key with the **Webauthn Register** required action, or in the Account Console.

WebAuthn needs HTTPS (or `localhost`), and credentials are bound to the domain, so changing the Keycloak hostname invalidates them.

### Passkeys

A passkey is a WebAuthn credential stored on the user's device or in their password manager (iCloud Keychain, Google Password Manager, 1Password, ...), and usually synced between their devices. The user logs in by unlocking the device with fingerprint, face or PIN, with **no password at all**. That is still MFA: the device is something they have, and the biometric or PIN is something they are or know.

Passkeys are fully supported (GA) since Keycloak 26.4 and integrated into the default login form:

1. Enable them in Authentication > Policies > Webauthn Passwordless Policy > **Enable Passkeys**.
2. Users register a passkey with the **Webauthn Register Passwordless** required action, or in the Account Console (Account security > Signing in > Passkey).
3. On the login page, the browser offers the passkey (in the username field autofill or with a "Sign in with Passkey" button). Users without a passkey still log in with their password.

Passkeys use the Webauthn **Passwordless** Policy, while security keys as a second factor use the Webauthn Policy, so both can be configured independently.

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
