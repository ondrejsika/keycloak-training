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

app.get('/foo-edit', keycloak.protect('realm:foo-editor'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('Foo edit!');
});

app.get('/bar-edit', keycloak.protect('realm:bar-editor'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('Bar edit!');
});

app.get('/foo-view', keycloak.protect('realm:foo-viewer'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('Foo view!');
});

app.get('/bar-view', keycloak.protect('realm:bar-viewer'), function (req, res) {
  res.setHeader('content-type', 'text/plain');
  res.send('Bar view!');
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
