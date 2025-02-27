require("dotenv").config();
const express = require('express');
const axios = require('axios');
const jwt = require('jsonwebtoken');
const qs = require('qs');

const app = express();

const keycloakConfig = {
    realm: process.env.KEYCLOAK_REALM,
    authServerUrl: process.env.KEYCLOAK_AUTH_SERVER_URL,
    clientId: process.env.KEYCLOAK_CLIENT_ID,
    clientSecret: process.env.KEYCLOAK_CLIENT_SECRET,
    redirectUri: process.env.ORIGIN+"/callback"
};

// Step 1: Redirect user to Keycloak login
app.get('/', (req, res) => {
    const authUrl = `${keycloakConfig.authServerUrl}/realms/${keycloakConfig.realm}/protocol/openid-connect/auth` +
        `?client_id=${keycloakConfig.clientId}` +
        `&response_type=code` +
        `&redirect_uri=${keycloakConfig.redirectUri}` +
        `&scope=openid email profile`;

    res.redirect(authUrl);
});

// Step 2: Handle Keycloak callback and exchange code for tokens
app.get('/callback', async (req, res) => {
    const { code } = req.query;

    if (!code) {
        return res.status(400).send("Authorization code not found");
    }

    try {
        // Exchange authorization code for tokens
        const tokenResponse = await axios.post(
            `${keycloakConfig.authServerUrl}/realms/${keycloakConfig.realm}/protocol/openid-connect/token`,
            qs.stringify({
                client_id: keycloakConfig.clientId,
                client_secret: keycloakConfig.clientSecret,
                grant_type: "authorization_code",
                code: code,
                redirect_uri: keycloakConfig.redirectUri
            }),
            { headers: { "Content-Type": "application/x-www-form-urlencoded" } }
        );

        const accessToken = tokenResponse.data.access_token;
        const idToken = tokenResponse.data.id_token;

        res.json({
            access_token: jwt.decode(accessToken),
            id_token: jwt.decode(idToken)
        });
    } catch (error) {
        console.error("Token exchange error:", error.response?.data || error.message);
        res.status(500).send("Failed to get tokens");
    }
});

app.listen(process.env.PORT, () => console.log('Server running on '+process.env.ORIGIN));
