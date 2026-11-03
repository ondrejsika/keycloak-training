require("dotenv").config();
const express = require('express');
const axios = require('axios');
const crypto = require('crypto');
const jose = require('jose');
const qs = require('qs');

const app = express();

const keycloakConfig = {
    realm: process.env.KEYCLOAK_REALM,
    authServerUrl: process.env.KEYCLOAK_AUTH_SERVER_URL,
    clientId: process.env.KEYCLOAK_CLIENT_ID,
    clientSecret: process.env.KEYCLOAK_CLIENT_SECRET,
    redirectUri: process.env.ORIGIN+"/callback"
};

const issuer = `${keycloakConfig.authServerUrl}/realms/${keycloakConfig.realm}`;

// Public keys of the realm, used to verify signatures of tokens
const jwks = jose.createRemoteJWKSet(new URL(`${issuer}/protocol/openid-connect/certs`));

// state -> PKCE code_verifier, in memory for simplicity of the example
const pendingLogins = new Map();

// Step 1: Redirect user to Keycloak login
app.get('/', (req, res) => {
    // Random state protects against CSRF
    const state = crypto.randomBytes(16).toString('base64url');
    // PKCE protects the authorization code against interception
    const codeVerifier = crypto.randomBytes(32).toString('base64url');
    const codeChallenge = crypto.createHash('sha256').update(codeVerifier).digest('base64url');

    pendingLogins.set(state, codeVerifier);

    const params = new URLSearchParams({
        client_id: keycloakConfig.clientId,
        response_type: "code",
        redirect_uri: keycloakConfig.redirectUri,
        scope: "openid email profile",
        state: state,
        code_challenge: codeChallenge,
        code_challenge_method: "S256"
    });

    res.redirect(`${issuer}/protocol/openid-connect/auth?${params}`);
});

// Step 2: Handle Keycloak callback and exchange code for tokens
app.get('/callback', async (req, res) => {
    const { code, state } = req.query;

    if (!code) {
        return res.status(400).send("Authorization code not found");
    }

    const codeVerifier = pendingLogins.get(state);
    if (!codeVerifier) {
        return res.status(400).send("State did not match");
    }
    pendingLogins.delete(state);

    try {
        // Exchange authorization code for tokens
        const tokenResponse = await axios.post(
            `${issuer}/protocol/openid-connect/token`,
            qs.stringify({
                client_id: keycloakConfig.clientId,
                client_secret: keycloakConfig.clientSecret,
                grant_type: "authorization_code",
                code: code,
                redirect_uri: keycloakConfig.redirectUri,
                code_verifier: codeVerifier
            }),
            { headers: { "Content-Type": "application/x-www-form-urlencoded" } }
        );

        const accessToken = tokenResponse.data.access_token;
        const idToken = tokenResponse.data.id_token;

        // Verify signature, issuer and expiration of tokens
        // Access Token has "aud": "account" unless an audience mapper is configured, so audience is not checked
        const { payload: accessTokenPayload } = await jose.jwtVerify(accessToken, jwks, { issuer });
        // ID Token is always issued for our client
        const { payload: idTokenPayload } = await jose.jwtVerify(idToken, jwks, { issuer, audience: keycloakConfig.clientId });

        res.json({
            access_token: accessTokenPayload,
            id_token: idTokenPayload
        });
    } catch (error) {
        console.error("Login error:", error.response?.data || error.message);
        res.status(500).send("Failed to get tokens");
    }
});

app.listen(process.env.PORT, () => console.log('Server running on '+process.env.ORIGIN));
