#!/usr/bin/env node
// Measure the weather
//      Soil moisture with SparkFun Soil Moisture Sensor
//          https://www.sparkfun.com/products/13322
//      Barometric presure and temperature with BMP085
//          https://www.sparkfun.com/products/retired/11282

// Wire the soil sensor so Vcc is on pin POWER and SIG on on soilPin

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
            filename: '/var/run/log/tempSoil.log',
            handleExceptions: true,
            json: true,
            maxsize: 1024000, // 1MB
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
var soilPin = 'P9_40';     // Attach soil sensor here
var POWER = 'P9_41';        // Only turn on sensor when reading it.
var ms = 1*60*1000;               // Repeat time

// var filename = "/home/yoder/exercises/phant/keys_weather.json";
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

var temp, 
    pressure, 
    soil;

var barometer = new BMP085();

setInterval(readWeather, ms);

b.pinMode(POWER, b.OUTPUT, 7, '', '', readWeather);

function readWeather() {
    barometer.read(postTemp);
    b.digitalWrite(POWER, 1, readSoil);     // Turn sensor on
    b.analogRead(soilPin, postSoil);
}

function readSoil(x) {
    if(x.value) {
        b.analogRead(soilPin, postSoil);
    }
}

function postSoil(x) {
    b.digitalWrite(POWER, 0);       // Turn sensor off
    soil = x.value.toFixed(4);
    if(x.err) {
        logger.error('x.err = ' + x.err);
        logger.error('x.value = ' + x.value);
        logger.error("url: " + url);
    }

    // logger.info("soil: " + soil);
    
    if(temp) {      // Wait until both the soil and temp have reported back.
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
    
    if(soil) {      // Wait until both the soil and temp have reported back.
        postWeather();
    } else {
        logger.info("Waiting for soil");
    }
}

function postWeather() {
    // Both temp and soil have replied
    var url = util.format(urlBase, soil, pressure, temp);
    // var url = util.format(urlBase, 0, pressure, temp);
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
    soil = '';
}