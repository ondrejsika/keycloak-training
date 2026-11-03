require("dotenv").config();
const express = require("express");
const { auth, requiresAuth } = require("express-openid-connect");

var app = express();

// Adds /login, /callback and /logout routes and keeps session in encrypted cookie
app.use(auth({
  issuerBaseURL: process.env.KEYCLOAK_AUTH_SERVER_URL + '/realms/' + process.env.KEYCLOAK_REALM,
  baseURL: process.env.ORIGIN,
  clientID: process.env.KEYCLOAK_CLIENT_ID,
  clientSecret: process.env.KEYCLOAK_CLIENT_SECRET,
  secret: process.env.SESSION_SECRET,
  authRequired: false,
  // Logout also from Keycloak, not only from this app
  idpLogout: true,
  authorizationParams: {
    response_type: 'code',
    scope: 'openid profile email',
  },
}));

// Keycloak puts roles only into Access Token (not ID Token), so check roles there.
// "realm:<role>" checks realm role, "<role>" checks client role of this client.
function requireRole(role) {
  return [requiresAuth(), async function (req, res, next) {
    let accessToken = req.oidc.accessToken;
    if (accessToken.isExpired()) {
      try {
        accessToken = await accessToken.refresh();
      } catch (err) {
        return next(err);
      }
    }

    // Token was received directly from Keycloak token endpoint (over TLS),
    // so it is enough to decode it, the signature does not have to be verified
    const claims = JSON.parse(Buffer.from(accessToken.access_token.split('.')[1], 'base64url'));

    const roles = role.startsWith('realm:')
      ? claims.realm_access?.roles
      : claims.resource_access?.[process.env.KEYCLOAK_CLIENT_ID]?.roles;
    const roleName = role.replace(/^realm:/, '');

    if (!roles?.includes(roleName)) {
      return res.status(403).send('Access denied');
    }
    next();
  }];
}

app.get('/realm-edit', requireRole('realm:editor'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('Edit! (realm role)');
});

app.get('/realm-view', requireRole('realm:viewer'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('View! (realm role)');
});

app.get('/edit', requireRole('editor'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('Edit!');
});

app.get('/view', requireRole('viewer'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('View!');
});

app.get('/administrator', requireRole('administrator'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('Administrator!');
});

app.get('/uzivatel', requireRole('uzivatel'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('Uzivatel!');
});

app.get('/public', function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('Public message!');
});

app.get("/secure", requiresAuth(), (req, res) => {
  res.json({ message: "This is a secure endpoint.", user: req.oidc.user });
});

app.get('/', function (req, res) {
  res.sendFile(__dirname + '/index.html');
});

app.listen(process.env.PORT, function () {
  console.log('Server started on 0.0.0.0:'+process.env.PORT+', see '+process.env.ORIGIN);
});
