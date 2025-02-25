require("dotenv").config();
const express = require("express");
const session = require("express-session");
const Keycloak = require("keycloak-connect");
var cors = require('cors');

var app = express();

app.use(cors());
app.use(express.static('.'))

var memoryStore = new session.MemoryStore();

app.use(session({
  secret: 'example',
  resave: false,
  saveUninitialized: true,
  store: memoryStore
}));

const keycloak = new Keycloak({ store: memoryStore }, {
    "realm": process.env.KEYCLOAK_REALM,
    "auth-server-url": process.env.KEYCLOAK_AUTH_SERVER_URL,
    "ssl-required": "external",
    "resource": process.env.KEYCLOAK_CLIENT_ID,
    "credentials": {
        "secret": process.env.KEYCLOAK_CLIENT_SECRET
    },
    "confidential-port": 0
});

app.use(keycloak.middleware());

app.get('/edit', keycloak.protect('editor'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('Edit!');
});

app.get('/view', keycloak.protect('viewer'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('View!');
});

app.get('/administrator', keycloak.protect('administrator'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('Administrator!');
});

app.get('/uzivatel', keycloak.protect('uzivatel'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('Uzivatel!');
});

app.get('/public', function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('Public message!');
});

app.get("/secure", keycloak.protect(), (req, res) => {
  res.json({ message: "This is a secure endpoint." });
});

app.get('/', function (req, res) {
  res.render('index.html');
});

app.listen(8001, function () {
  console.log('Server started on 0.0.0.0:8001, see http://127.0.0.1:8001');
});
