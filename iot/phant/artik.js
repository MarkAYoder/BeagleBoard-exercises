#!/usr/bin/env node
// Measure the weather and post on Artik
//      Barometric presure and temperature with BMP085
//          https://www.sparkfun.com/products/retired/11282

// Go to http://14.139.34.32:8080/streams/make and create a new stream
// Save the keys json file and copy to keys.json
// Run this script

var https         = require('https');
var BMP085        = require('bmp085');
var util          = require('util');
var ms = 15*60*1000;               // Repeat time

// Go to https://artik.cloud/my/devices and click on the gear
// for the device you are posting to.  Use the "DEVICE ID
var deviceID = '96fc439d2af94d2fa9d9cf5720a58ae6';      // weather

var barometer = new BMP085({device: '/dev/i2c-2', mode: '2'});

setInterval(readWeather, ms);

readWeather();

function readWeather() {
    barometer.read(postTemp);
}

function postTemp(data) {
    var postData = JSON.stringify({
        "data": {
            pressure:   data.pressure.toFixed(1),
            temp:       data.temperature
        },
        "sdid": deviceID,
        "type": "message"
      });
      
    // console.log('postData: ' + postData);
    
    // Go to https://developer.artik.cloud/api-console/ and click
    // on "Get Current User Profile" then click on "TRY IT!"
    var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer 40a617e4e83e45ccb5167ef50a8e0246",
        "Content-Length": postData.length
        };

    var options = {
      hostname: 'api.artik.cloud',
      path: '/v1.1/messages',
      port: 443,
      method: 'POST',
      headers: header
    };
    
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
    
    req.write(postData);

    req.end();
    
    req.on('error', function(e) {
      console.error("error: " + e);
    });

}
