#!/usr/bin/env node
// Measure the weather
//      Barometric presure and temperature with BMP085
//          https://www.sparkfun.com/products/retired/11282

// Go to http://14.139.34.32:8080/streams/make and create a new stream
// Save the keys json file and copy to keys.json
// Run this script

var https         = require('https');
var BMP085        = require('bmp085');
var util          = require('util');
// var fs            = require('fs');
// var b             = require('bonescript');
var ms = 15*1000;               // Repeat time

var deviceID = '96fc439d2af94d2fa9d9cf5720a58ae6';      // weather

// console.log(util.inspect(request));
// request.debug = true;

var barometer = new BMP085({device: '/dev/i2c-2', mode: '2'});

setInterval(readWeather, ms);

readWeather();

function readWeather() {
    barometer.read(postTemp);
}

function postTemp(data) {
    // logger.debug("data: " + util.inspect(data));
    var temp = data.temperature;
    var pressure = data.pressure.toFixed(1);

    // logger.debug("temp: " + temp);
    // logger.debug("pressure: " + pressure);
    
    var postData = JSON.stringify({
        "data": {
            pressure: pressure,
            temp: temp
        },
        "sdid": deviceID,
        "type": "message"
      });
      
    console.log('postData: ' + postData);
    
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
