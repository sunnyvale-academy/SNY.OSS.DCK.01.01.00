'use strict';

const express = require('express');

// Constants
const PORT = 3000;
const HOST = '0.0.0.0';



// App
const app = express();

app.use(express.static('public'));

app.get('/', (req, res) => {
  res.send('Hello world\n');
});

app.get('/foo', (req, res) => {
  var someHTML = "<img src='logo.png' alt='Docker Logo'>"
  res.send(someHTML);
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);