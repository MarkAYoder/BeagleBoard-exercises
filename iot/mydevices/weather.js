#!/usr/bin/env node
// Measure the weather
//      Barometric presure and temperature with BMP085
//          https://www.sparkfun.com/products/retired/11282

// Go to http://14.139.34.32:8080/streams/make and create a new stream
// Save the keys json file and copy to keys.json
// Run this script

// Logging 
// https://www.npmjs.com/package/winston
// var winston = require('winston');

// var logger = new winston.Logger({
//     transports: [
//         new winston.transports.File({
//             level: 'debug',
//             filename: '/home/debian/weather.log',
//             handleExceptions: true,
//             json: true,
//             maxsize: 1024000, // 1MB
//             maxFiles: 5
//         }),
//         new winston.transports.Console({
//             level: 'info',
//             handleExceptions: true,
//             json: false,
//             colorize: true
//         })
//     ],
//     exitOnError: false
// });

// var request       = require('request');
var BMP085        = require('bmp085');
var util          = require('util');
// var fs            = require('fs');
var ms = 15*1000;               // Repeat time
var Cayenne = require('cayennejs');

// console.log(util.inspect(request));
// request.debug = true;

// Initiate MQTT API
const cayenneClient = new Cayenne.MQTT({
  username: "9d396770-6f4d-11e8-84d1-4d9372e87a68",
  password: "b977512eb348da0f00a02d000acf36d324ae6346",
  clientId: "a4153ba0-6f4d-11e8-ab28-e7cb4e37d88a"
});

var barometer = new BMP085({device: '/dev/i2c-2', mode: '2'});

cayenneClient.connect((err, mqttClient) => {
  var test = cayenneClient.getDataTopic(3);
  console.log("test: " + test);

    setInterval(readWeather, ms);
    
    readWeather();
    
    function readWeather() {
        barometer.read(postTemp);
    }
    
    function postTemp(data) {
        // logger.debug("data: " + util.inspect(data));
        console.log("data: " + util.inspect(data));
        var temp = data.temperature;
        var pressure = data.pressure.toFixed(1);
    
        // logger.debug("temp: " + temp);
        // logger.debug("pressure: " + pressure);
        console.log("temp: " + temp);
        console.log("pressure: " + pressure);

        // dashboard widget automatically detects datatype & unit
        cayenneClient.celsiusWrite(3, temp);
        
        // sending raw values without datatypes
        cayenneClient.pascalWrite(4, pressure);
        
        // subscribe to data channel for actions (actuators)
        cayenneClient.on("cmd9", function(data) {
        console.log(data);
        });
    }
});