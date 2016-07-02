#!/usr/bin/env node
// Playing with Artik
var https = require('https');

var header = {
    "Content-Type": "application/json",
    "Authorization": "Bearer 40a617e4e83e45ccb5167ef50a8e0246"
    };

var options = {
  hostname: 'api.artik.cloud',
  path: '/v1.1/users/self',
  port: 443,
  method: 'GET',
  headers: header
};

var req = https.request(options, function(res) {
  console.log("statusCode: ", res.statusCode);
  console.log("headers: ", res.headers);

  res.on('data', function(d) {
      console.log("data:");
    process.stdout.write(d + '\n');
  });
});

req.end();

req.on('error', function(e) {
  console.error("error: " + e);
});
