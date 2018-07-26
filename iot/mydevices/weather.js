#!/usr/bin/env node
// Measure the weather
//      Barometric presure and temperature with BMP085
//          https://www.sparkfun.com/products/retired/11282

// Go to http://14.139.34.32:8080/streams/make and create a new stream
// Save the keys json file and copy to keys.json
// Run this script

// Logging 
// https://www.npmjs.com/package/winston
// const winston = require('winston');

// const logger = new winston.Logger({
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

// const request       = require('request');
const BMP085        = require('bmp085');
const util          = require('util');
const fs            = require('fs');
const ms = 15*1000;               // Repeat time
const Cayenne = require('cayennejs');

// console.log(util.inspect(request));
// request.debug = true;

// Initiate MQTT API
const filename = "/home/debian/exercises/iot/mydevices/keys_home.json";
const keys = JSON.parse(fs.readFileSync(filename));
const cayenneClient = new Cayenne.MQTT(keys);

const barometer = new BMP085({device: '/dev/i2c-2', mode: '2'});

var tempOld = NaN;
var pressOld = NaN;

cayenneClient.connect((err, mqttClient) => {
  const test = cayenneClient.getDataTopic(3);
  console.log("test: " + test);

    setInterval(readWeather, ms);
    
    readWeather();
    
    function readWeather() {
        barometer.read(postTemp);
    }
    
    function postTemp(data) {
        // logger.debug("data: " + util.inspect(data));
        console.log("data: " + util.inspect(data));
        const temp = data.temperature;
        const pressure = data.pressure.toFixed(1);
    
        // logger.debug("temp: " + temp);
        // logger.debug("pressure: " + pressure);
        console.log("temp: " + temp);
        console.log("pressure: " + pressure);

        if(temp !== tempOld) {
          console.log("Updating from: " + tempOld + " " + pressOld);
          // dashboard widget automatically detects datatype & unit
          cayenneClient.celsiusWrite(3, temp);
          
          // sending raw values without datatypes
          cayenneClient.pascalWrite(4, pressure);
          
          // subscribe to data channel for actions (actuators)
          cayenneClient.on("cmd9", function(data) {
          console.log(data);
          });
          tempOld  = temp;
          pressOld = pressure;
        }
    }
});