#!/usr/bin/env node
// Playing with Artik
var https = require('https');

var id = 'cd98e36c092345c89974f06decfa4540';
var deviceID = '271e863bf1f04c95aa3735f9055f2781';  // My GearFit Device - simulated
deviceID = '96fc439d2af94d2fa9d9cf5720a58ae6';      // weather2 - From Beagle

var postData = JSON.stringify({
    "data": {
        pressure: 31,
        temp: 60
    },
    "sdid": deviceID,
    "type": "message"
  });

// I tried to use the simpler MQTT, but didn't get it to work.
// var postData = JSON.stringify({
//     "state": 0,
//     "stepCount": 1,
//     "heartRate": 20,
//     "activity": 30
//   });

console.log('postData: ' + postData);

var header = {
    "Content-Type": "application/json",
    "Authorization": "Bearer 40a617e4e83e45ccb5167ef50a8e0246",
    "Content-Length": postData.length
    };
    
var paths = [  // Doesn't like sending several at once.
    // '/users/self',
    // '/users/' + id + '/devices?count=100&includeProperties=true',
    // '/devices/' + deviceID + '?properties=true',   // Use GET
    '/messages',    // Use GET or POST
    // '/messages/last?count=1&sdids=' + deviceID   // GET use to learn valid fields
    // '/messages/' + deviceID      // This should work with MQTT, but didn't
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
