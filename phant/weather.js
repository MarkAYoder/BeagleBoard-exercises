#!/usr/bin/env node
// Measure the weather
//      humidity with SparkFun Humidity Sensor Breakout - HIH-4030
//          https://www.sparkfun.com/products/9569
//      Barometric presure and temperature with BMP085
//          https://www.sparkfun.com/products/retired/11282

// Go to http://14.139.34.32:8080/streams/make and create a new stream
// Save the keys json file and copy to keys.json
// Run this script

// Logging 
// https://www.npmjs.com/package/winston
var winston = require('winston');

var logger = new winston.Logger({
    transports: [
        new winston.transports.File({
            level: 'debug',
            filename: 'weather.log',
            handleExceptions: true,
            json: true,
            maxsize: 1024000, //5MB
            maxFiles: 5
        }),
        new winston.transports.Console({
            level: 'info',
            handleExceptions: true,
            json: false,
            colorize: true
        })
    ],
    exitOnError: false
});

var request       = require('request');
var BMP085        = require('bmp085');
var util          = require('util');
var fs            = require('fs');
var b             = require('bonescript');
var humidPin = 'P9_40';     // Attach HIH-4030 here
var ms = 60*1000;               // Repeat time

var filename = "/home/yoder/exercises/phant/keys_weather.json";
var filename = "/root/exercises/phant/keys_weather.json";
// logger.debug("process.argv.length: " + process.argv.length);
if(process.argv.length === 3) {
    filename = process.argv[2];
}
var keys = JSON.parse(fs.readFileSync(filename));
// logger.info("Using: " + filename);
logger.info("Title: " + keys.title);
// logger.debug(util.inspect(keys));

var urlBase = keys.inputUrl + "/?private_key=" + keys.privateKey + "&humidity=%s&pressure=%s&temp=%s";

// Read 

var temp     = 'NaN', 
    pressure = 'NaN', 
    humidity = 'NaN';
postWeather();      // Make first positing NaN so plot will have a gap.

var barometer = new BMP085();

setInterval(readWeather, ms);

readWeather();

function readWeather() {
    barometer.read(postTemp);
    b.analogRead(humidPin, postHumidity);
}

function postHumidity(x) {
    humidity = x.value.toFixed(4);
    if(x.err) {
        logger.error('x.err = ' + x.err);
        logger.error('x.value = ' + x.value);
        logger.error("url: " + url);
    }

    // logger.info("humidity: " + humidity);
    
    if(temp) {      // Wait until both the humidity and temp have reported back.
        postWeather();
    } else {
        logger.info("Waiting for temp");
    }
}

function postTemp(data) {
    // logger.debug("data: " + util.inspect(data));
    temp = data.temperature;
    pressure = data.pressure.toFixed(1);

    // logger.debug("temp: " + temp);
    // logger.debug("pressure: " + pressure);
    
    if(humidity) {      // Wait until both the humidity and temp have reported back.
        postWeather();
    } else {
        logger.info("Waiting for humidity");
    }
}

function postWeather() {
    // Both temp and humidity have replied
    var url = util.format(urlBase, humidity, pressure, temp);
    // logger.debug("url: ", url);
    request(url, function (error, response, body) {
        if (!error && response.statusCode == 200) {
            logger.info(body); 
        } else {
            logger.error("error=" + error + " response=" + JSON.stringify(response));
        }
    })
    // Reset variables for next time.
    temp = '';
    pressure = '';
    humidity = '';
}