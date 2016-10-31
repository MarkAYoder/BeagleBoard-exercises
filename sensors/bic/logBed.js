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

var i2c           = require('i2c');
var request       = require('request');
var child_process = require('child_process');
var util          = require('util');
var fs            = require('fs');
var ms = 5*1000;               // Repeat time

var bus = '/dev/i2c-2';	// Which i2c bus
var addr = 0x40;		// Address on bus

var wait = 10;  // time in ms to wait from giving command to reading data.

var sensor = new i2c(addr, {device: bus});
var temperature;
var humidity;

// console.log(util.inspect(request));
// request.debug = true;

var filename = "/root/exercises/sensors/bic/bedKeys.json";
// logger.debug("process.argv.length: " + process.argv.length);
if(process.argv.length === 3) {
    filename = process.argv[2];
}
var keys = JSON.parse(fs.readFileSync(filename));
// logger.info("Using: " + filename);
logger.info("Title: " + keys.title);
logger.debug(util.inspect(keys));

var urlBase = keys.inputUrl + "/?private_key=" + keys.privateKey + "&templow=%s&tempmid=%s&temphigh=%s&humidity=%s&pressure=%s&ph=%s&extra=%s";

readWeather();

function readWeather() {
    // Send humidity measurement command(0xF5)
    // logger.debug("Sending read humidity command...");
    sensor.writeBytes(0xf5, [1], function(err) {
    	if(err) {
    		logger.debug("writeBytes: 0xf5: " + err);
    	}
    	setTimeout(readHumid, wait);	// Give device time to make measurment
    });
    
    // Read 2 bytes of humidity data
    // humidity msb, humidity lsb
    function readHumid() {
    	sensor.read(2, function(err, res) {
    		if(err) {
    			logger.debug("readHumid: err: " + err);
    		}
    		// logger.debug("readHumid: " + res);
    		humidity = ((((res[0]<<8) + res[1]) * 125) / 65536) - 6;	// p21
    		humidity = humidity.toFixed(2);
    		logger.debug("humidity: " + humidity);
    		sendTempCmd();
    	});
    }
    
    // Send temperature measurement command(0xF3)
    // The exe0 command says to return the temp measured when the humidity was read. p21
    function sendTempCmd() {
    	// logger.debug("Sending read temperature command...");
    	sensor.writeBytes(0xe0, [1], function(err) {
    		if(err) {
    			logger.debug("writeBytes: 0xe0: " + err);
    		}
    		readTemp();	// No need to wait since it was computed with humidity
    	});
    }
    
    // Read 2 bytes of temperature data
    // temperature msb, temperature lsb
    function readTemp() {
    	sensor.read(2, function(err, res) {
    		if(err) {
    			logger.debug("readTemp: err: " + err);
    		}
    		// logger.debug("readTemp: " + res);
    		temperature = ((((res[0]<<8) + res[1]) * 175.72) / 65536) - 46.85;
    		temperature = temperature.toFixed(2);
    		logger.debug("temperature: " + temperature);

            logger.debug("humid: " + humidity);
            logger.debug("temp:  " + temperature);
        
            var url = util.format(urlBase, temperature, temperature, temperature, humidity, 0, 0, 0);
            logger.debug("url: ", url);
            request(url, {timeout: 10000}, function (error, response, body) {
                if (!error && response.statusCode == 200) {
                    logger.info(body); 
                } else {
                    logger.error("error=" + error + " response=" + JSON.stringify(response));
                }
            });
            
            // console.log("About to make new oled");
            // Write to OLED display
            // Use OLED
            var oled = require('oled-spi');
            var font = require('oled-font-5x7');
            var opts = {
                device: "/dev/spidev2.1",
                width:  128,
                height: 64,
                dcPin:  7,
                rstPin: 20
            };
            var oled = new oled(opts);

            oled.begin(function() {
                var xoff = 32;
                var yoff = 16;
                oled.turnOnDisplay();
                oled.clearDisplay();
                oled.setCursor(0+xoff, 0+yoff);
                oled.writeString(font, 1, 'Temp:', 1, true);
                oled.setCursor(0+xoff, 8+yoff);
                oled.writeString(font, 1, '    ' + (temperature*9/5+32).toFixed(0), 1, true);
                
                oled.setCursor(0+xoff, 16+yoff);
                oled.writeString(font, 1, 'Humid:', 1, true);
                oled.setCursor(0+xoff, 24+yoff);
                oled.writeString(font, 1, '    ' + humidity, 1, true);
            });
    	});
    }
}
