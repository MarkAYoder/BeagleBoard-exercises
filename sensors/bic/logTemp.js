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
            filename: '/var/run/log/bic.log',
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

var b             = require('bonescript');
var request       = require('request');
var child_process = require('child_process');
var util          = require('util');
var fs            = require('fs');
var ms = 5*1000;               // Repeat time

// console.log(util.inspect(request));
// request.debug = true;
// 22-Aug-2016 - Added ph
// The pH sensor produces and analog value that has some noise on it.
//  We'll read several consecutive values and average them to remove the noise.


var filename = "/root/exercises/sensors/bic/phantKeys.json";
// logger.debug("process.argv.length: " + process.argv.length);
if(process.argv.length === 3) {
    filename = process.argv[2];
}
var keys = JSON.parse(fs.readFileSync(filename));
// logger.info("Using: " + filename);
logger.info("Title: " + keys.title);
// logger.debug(util.inspect(keys));

var urlBase = keys.inputUrl + "/?private_key=" + keys.privateKey + "&templow=%s&tempmid=%s&temphigh=%s&humidity=%s&pressure=%s&ph=%s&extra=%s";
// var barometer = new BMP085({device: '/dev/i2c-2', mode: '2'});

var w1={
    low: "/sys/bus/w1/devices/28-0000075f8228/w1_slave",
    mid: "/sys/bus/w1/devices/28-00000128197d/w1_slave",
    high:"/sys/bus/w1/devices/28-0000074b85ea/w1_slave"
    };

// setInterval(readWeather, ms);

// Read several analog values and average for the pH
var pH = 'P9_36';
var ms = 40;    // Time between values
var data = [];
var MAXDATA = 10;
var pHvalue;
var currentIndex = 0;

var timer = setInterval(readpH, ms);
function readpH() {
    b.analogRead(pH, collectpH);
}

function collectpH(x) {
    if(x.err) {
        console.log('x: ' , x);
        return;
    }
    console.log('\tvalue: ' + x.value);
    data[currentIndex++] = x.value;
    if(currentIndex>=MAXDATA) { //  True when you have enough values
        clearInterval(timer);   // Stop reading the pH
        logpH();
    }
}
function logpH() {
    // Find average value
    var sum=0;
    for(i=0; i<MAXDATA; i++) {
        sum += data[i];
    }
    var sensorValue = sum/MAXDATA;
    console.log('sensorValue: ' + sensorValue);
    // Convert to pH
    pHvalue = (4-(6/0.289*(sensorValue-0.492))).toFixed(1);
    console.log('pHvalue: ' + pHvalue);
    
    // Now read the temp and humidity
    readWeather();
}

function getTemp(data) {
    var temp = data.slice(data.indexOf('t=')+2, -1);// Pull out temp
    temp = temp.slice(0,2) + '.' + temp.slice(2);   // Put decimal in right place
    return temp;
}
function getHumid(data) {
    var temp = data.slice(data.indexOf('t=')+2, -1);
    temp = temp.slice(0,2) + '.' + temp.slice(2);
    return temp;
}

function readWeather() {
    child_process.exec('/root/exercises/sensors/bic/si7021',
    function (error, stdout, stderr) {
        console.log("stdout: " + stdout);
        var humid = stdout.substring(0, 5);

        if(error) { console.log('error: ' + error); }
        if(stderr) {console.log('stderr: ' + stderr); }
        console.log("humid: " + humid);

        tempLow = getTemp(fs.readFileSync(w1.low,  {encoding: 'utf8'}));
        tempMid = getTemp(fs.readFileSync(w1.mid,  {encoding: 'utf8'}));
        tempHigh= getTemp(fs.readFileSync(w1.high, {encoding: 'utf8'}));
    
        logger.debug("low: " + tempLow);
        logger.debug("mid: " + tempMid);
        logger.debug("high:" + tempHigh);
    
        var url = util.format(urlBase, tempLow, tempMid, tempHigh, humid, 0, pHvalue, 0);
        logger.debug("url: ", url);
        request(url, {timeout: 10000}, function (error, response, body) {
            if (!error && response.statusCode == 200) {
                logger.info(body); 
            } else {
                logger.error("error=" + error + " response=" + JSON.stringify(response));
            }
        });
    });
}
