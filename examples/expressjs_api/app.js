var express = require('express');
var session = require('express-session');
var Keycloak = require('keycloak-connect');
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

var keycloak = new Keycloak({
   store: memoryStore
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

app.get('/', function (req, res) {
  res.render('index.html');
});

app.listen(3001, function () {
  console.log('Started at port 3001');
});
