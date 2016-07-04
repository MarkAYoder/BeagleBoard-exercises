#!/usr/bin/env node
// Measure the weather
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
            filename: '/var/run/log/weather.log',
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
var ms = 15*60*1000;               // Repeat time

// console.log(util.inspect(request));
// request.debug = true;

// var filename = "/home/yoder/exercises/iot/phant/keys_weather.json";
var filename = "/root/exercises/iot/phant/keys_weather.json";
// logger.debug("process.argv.length: " + process.argv.length);
if(process.argv.length === 3) {
    filename = process.argv[2];
}
var keys = JSON.parse(fs.readFileSync(filename));
// logger.info("Using: " + filename);
logger.info("Title: " + keys.title);
// logger.debug(util.inspect(keys));

var urlBase = keys.inputUrl + "/?private_key=" + keys.privateKey + "&humidity=%s&pressure=%s&temp=%s";
var urlBaseIS = 'https://groker.initialstate.com/api/events?accessKey=RdWtHlEJV0FIH1X4REFw44OfMxxJEdne&bucketKey=BA4RKHNTUVR3&Temp=%s&Pressure=%s';
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
    
    var url = util.format(urlBase, 0, pressure, temp);
    logger.debug("url: ", url);
    request(url, {timeout: 10000}, function (error, response, body) {
        if (!error && response.statusCode == 200) {
            logger.info(body); 
        } else {
            logger.error("error=" + error + " response=" + JSON.stringify(response));
        }
    });
    
    var urlIS = util.format(urlBaseIS, temp, pressure);
    logger.debug("urlIS: ", urlIS);
    request(urlIS, {timeout: 10000}, function (error, response, body) {
        if (!error && response.statusCode == 204) {
            logger.info("Initial State success"); 
        } else {
            logger.error("error=" + error + " response=" + JSON.stringify(response));
        }
    });
}
