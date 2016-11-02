#!/usr/bin/env node
// Displays beadroom temp and humisity from Phant
// and outdoor temp and forcast from wunderground
// on SparkFun micro OLED display
// https://www.sparkfun.com/products/13003

console.log("Loading oled-spi...");
var oledspi = require('oled-spi');
var font    = require('oled-font-5x7');
var request = require('request');
var fs      = require('fs');
var util    = require('util'); 
var timeOut = 15*1000;       // On time

// spi options
var opts = {
    device: "/dev/spidev2.1",
    width:  128,
    height: 64,
    dcPin:  7,
    rstPin: 20
};
var oled = new oledspi(opts);

var filename = "/root/exercises/sensors/bic/bedKeys.json";
if(process.argv.length === 3) {
    filename = process.argv[2];
}
var keys = JSON.parse(fs.readFileSync(filename));
// console.log("Using: " + filename);
console.log("Title: " + keys.title);
// console.log(util.inspect(keys));

// Fill these in with two url requests.  Don't display until both have returned
var temperature = null;
var humidity    = null;
var weather     = null;

// Get Bedroom data from phant
var url = keys.outputUrl + "/latest.json";
request(url, {timeout: 10000}, function (err, res, body) {
    if(err) {
        console.log("err: " + err);
    }
    // console.log("res: " + util.inspect(res));
    // console.log("body: " + body);
    var data = JSON.parse(body)[0];
    // console.log("data: " + data);
    temperature = (data.tempmid*9/5+32).toFixed(1);
    humidity    = (data.humidity*1).toFixed(1);
    // console.log("Temperature: %d, Humidity: %d", temperature, humidity);
    
    if(weather) {   // Display if wunderground has already responded
        displayWeather();
    }
});

// Get outdoor temp and forcast from wunderground
var urlWeather = "http://api.wunderground.com/api/ec7eb641373d9256/conditions/forecast/q/IN/Brazil.json";
request(urlWeather, {timeout: 10000}, function(err, res, body) {
    if(err) {
        console.log("err: " + err);
    }
    weather = JSON.parse(body);
    // console.log("Temp:%s, lo:%s, hi:%s",
    //         weather.current_observation.temp_f,
    //         weather.forecast.simpleforecast.forecastday[0].low.fahrenheit,
    //         weather.forecast.simpleforecast.forecastday[0].high.fahrenheit
    //         );
    if(temperature) {   // Display if phant has already responded
        displayWeather();
    }
});

// Called after both phant and wunderground have responded.
function displayWeather() {
    // console.log('displayWeather()');
    oled.begin(function() {
        var xoff = 32;
        var yoff = 16;
        oled.turnOnDisplay();
        oled.clearDisplay();
        oled.setCursor(0+xoff, 0+yoff);
        oled.writeString(font, 1, 'Temp:'+ temperature, 1, true);
        oled.setCursor(0+xoff, 8+yoff);
        oled.writeString(font, 1, 'Hum: ' + humidity, 1, true);
        oled.setCursor(0+xoff, 16+yoff);
        oled.writeString(font, 1, 'Out: ' + weather.current_observation.temp_f, 1, true);
        oled.setCursor(0+xoff, 24+yoff);
        oled.writeString(font, 1, 
            'lo:  ' + weather.forecast.simpleforecast.forecastday[0].low.fahrenheit, 1, true);
        oled.setCursor(0+xoff, 32+yoff);
        oled.writeString(font, 1, 
            'hi:  ' + weather.forecast.simpleforecast.forecastday[0].high.fahrenheit, 1, true);
        oled.setCursor(0+xoff, 40+yoff);
        
        var d = new Date();
        oled.writeString(font, 1, '      ' + d.getHours() + ':' + d.getMinutes(), 1, true);
            

            
        setTimeout(off, timeOut);   // Only leave on for timeOut ms
    }); 
}

function off () {
    oled.turnOffDisplay();
}

console.log("Ready...");