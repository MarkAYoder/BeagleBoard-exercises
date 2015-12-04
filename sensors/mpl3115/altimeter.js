#!/usr/bin/env node
// Measure the weather
// https://learn.sparkfun.com/tutorials/mpl3115a2-pressure-sensor-hookup-guide?_ga=1.250115779.435039742.1438648588
// https://github.com/vmayoral/bb_altimeter/blob/master/scripts/mpl2115a2.py

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
var util          = require('util');
var fs            = require('fs');
var b             = require('bonescript');

var port  = '/dev/i2c-2';		// Using MPL3115 Altitude sensor
var mpl = 0x60;
var ms = 1*60*1000;           // Repeat time

// console.log(util.inspect(request));
// request.debug = true;

// var filename = "/home/yoder/exercises/iot/phant/keys_many.json";
var filename = "/root/exercises/iot/phant/keys_many.json";
// logger.debug("process.argv.length: " + process.argv.length);
if(process.argv.length === 3) {
    filename = process.argv[2];
}
var keys = JSON.parse(fs.readFileSync(filename));
// logger.info("Using: " + filename);
logger.info("Title: " + keys.title);
// logger.debug(util.inspect(keys));

var urlBase = keys.inputUrl + "/?private_key=" + keys.privateKey + 
    "&altitude=%s&co=%s&humidity=%s&pressure=%s&soil=%s&temp=%s";
    
b.i2cOpen(port, mpl);
b.i2cWriteBytes(port, 0x26, [0xb8]); // Set to Altimeter with an OSR = 128 
b.i2cWriteBytes(port, 0x13, [0x07]); // Enable Data Flags in PT_DATA_CFG
b.i2cWriteBytes(port, 0x26, [0xb9]); // Set Active (polling)

setInterval(readWeather, ms);

setTimeout(readWeather, 500);   // Give the sensor time to get started

function readWeather() {
    // i2cReadBytes(port, command, length, [callback])
	b.i2cReadBytes(port, 0x00, 6, postWeather);
}

function postWeather(data) {
    // logger.debug("data: " + util.inspect(data));
    var mplData;
    if(data.event === 'return') {
        mplData = {
            altitude:   data.return[1]<<8 | data.return[2],     // Units:  meters
            temp:       (((data.return[4]<<8 | data.return[5])<<16)>>16)/256    // Units: degree C
        };
        console.log("mplData: " + util.inspect(mplData));

    //  &altitude=%s&co=%s&humidity=%s&pressure=%s&soil=%s&temp=%s
        var url = util.format(urlBase, mplData.altitude, 0, 0, 0, mplData.temp);
        logger.debug("url: ", url);
        request(url, {timeout: 10000}, function (error, response, body) {
            if (!error && response.statusCode == 200) {
                logger.info(body); 
            } else {
                logger.error("error=" + error + " response=" + JSON.stringify(response));
            }
        });
    }
}
