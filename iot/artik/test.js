#!/usr/bin/env node
// Playing with Artik
var https = require('https');
var util  = require('util');
var querystring = require('querystring');

var postData = JSON.stringify({
    "data": {
        "state": 0,
        "stepCount": 1,
        "heartRate": 2,
        "activity": 30
    },
    "sdid": "271e863bf1f04c95aa3735f9055f2781",
    "type": "message"
  });

console.log('postData: ' + postData);

var header = {
    "Content-Type": "application/json",
    "Authorization": "Bearer 40a617e4e83e45ccb5167ef50a8e0246",
    "Content-Length": postData.length
    };
    
var id = 'cd98e36c092345c89974f06decfa4540';
var deviceID = '271e863bf1f04c95aa3735f9055f2781';
    
var paths = [
    // '/users/self',
    // '/users/' + id + '/devices?count=100&includeProperties=true',
    // '/devices/' + deviceID + '?properties=true',
    '/messages'
    ];


var options = {
  hostname: 'api.artik.cloud',
  path: '/v1.1/users/self',
  port: 443,
  method: 'POST',
  headers: header
};

for(var i=0; i<paths.length; i++) {
    options.path = '/v1.1' + paths[i];
    
    var req = https.request(options, function(res) {
      if(res.statusCode !== 200) {
        console.log("statusCode: ", res.statusCode);
        console.log("headers: ", res.headers);
      }
    
      res.on('data', function(d) {
        console.log("data:");
        process.stdout.write(d + '\n');
      });
    });
}

req.write(postData);

req.end();

req.on('error', function(e) {
  console.error("error: " + e);
});
