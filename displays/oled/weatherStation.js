#!/usr/bin/env node
// Displays beadroom temp and humisity from Phant
// and outdoor temp and forcast from wunderground
// on SparkFun micro OLED display
// https://www.sparkfun.com/products/13003
// Gets data from phant and weather underground.
// Displays as
//  Temp:
//  Hum:
//  Out:
//  lo:
//  hi:
//      time
// Where Temp and Hum come from phant are are measured in bedroom
//  Out is the outdoor temp from wunderground and lo and hi are the 
//  forecasted low and hi temps.

console.log("Loading oled-spi...");
var oledspi = require('oled-spi');
var font    = require('oled-font-5x7');
var request = require('request');
var fs      = require('fs');
var util    = require('util'); 

// Display on 15 seconds after last update.
var timeOut = 15*1000;      // On time
var timer   = null;         // Returned by setTimeout

// spi options
var opts = {
    device: "/dev/spidev2.1",
    width:  128,
    height: 64,
    dcPin:  7,
    rstPin: 20
};

var xoff = 32;  // oled works for a larger display.  Have to add these offsets
var yoff = 16;  // to make with work with this display
var oled = new oledspi(opts);
    oled.begin(function() {
        oled.clearDisplay();
        // Put a pixel in each corner
        // oled.drawPixel([
        //     [ 0+xoff,  0+yoff, 1],
        //     [ 0+xoff, 47+yoff, 1],
        //     [63+xoff,  0+yoff, 1],
        //     [63+xoff, 47+yoff, 1]
        // ]);
        // Draw a box in the middle
        // oled.drawLine( 2+xoff, 12+yoff,  2+xoff, 35+yoff, 1);
        // oled.drawLine(61+xoff, 12+yoff, 61+xoff, 35+yoff, 1);
        // oled.drawLine( 2+xoff, 12+yoff, 61+xoff, 12+yoff, 1);
        // oled.drawLine(61+xoff, 35+yoff,  2+xoff, 35+yoff, 1);
        // oled.setCursor(7+xoff, 20+yoff);
        // oled.writeString(font, 1, "Loading", 1, true);
        
        var d = new Date();
        oled.turnOnDisplay();
        oled.setCursor(0+xoff, 40+yoff);
        oled.writeString(font, 1, '      ' + d.getHours() + ':' + d.getMinutes(), 1, true);
    });

// Path to fson file telling which phant data to use
var filename = "/home/debian/exercises/sensors/bic/bedKeys.json";
if(process.argv.length === 3) {
    filename = process.argv[2];
}
var keys = JSON.parse(fs.readFileSync(filename));
// console.log("Using: " + filename);
console.log("Title: " + keys.title);
// console.log(util.inspect(keys));


// Get Bedroom data from phant
var url = keys.outputUrl + "/latest.json";
request(url, {timeout: 10000}, function (err, res, body) {
    if(err) {
        console.log("err phant: " + err);
    }
    // console.log("res: " + util.inspect(res));
    // console.log("body: " + body);
    var data = JSON.parse(body)[0];
    // console.log("data: " + data);
    var temperature = (data.tempmid*9/5+32).toFixed(1);
    var humidity    = (data.humidity*1).toFixed(1);
    // console.log("Temperature: %d, Humidity: %d", temperature, humidity);
    
    oled.turnOnDisplay();
    oled.setCursor(0+xoff, 0+yoff);
    oled.writeString(font, 1, 'Temp:'+ temperature, 1, true);
    oled.setCursor(0+xoff, 8+yoff);
    oled.writeString(font, 1, 'Hum: ' + humidity, 1, true);
    
    clearTimeout(timer);    // turn off time in case the other URL has gone first
    timer = setTimeout(off, timeOut);   // Only leave on for timeOut ms
});

// Get outdoor temp and forcast from wunderground
var urlWeather = "http://api.wunderground.com/api/ec7eb641373d9256/conditions/forecast/q/IN/Brazil.json";
request(urlWeather, {timeout: 10000}, function(err, res, body) {
    if(err) {
        console.log("err wunderground: " + err);
    }
    weather = JSON.parse(body);
    // console.log("Temp:%s, lo:%s, hi:%s",
    //         weather.current_observation.temp_f,
    //         weather.forecast.simpleforecast.forecastday[0].low.fahrenheit,
    //         weather.forecast.simpleforecast.forecastday[0].high.fahrenheit
    //         );

    oled.turnOnDisplay();
    oled.setCursor(0+xoff, 16+yoff);
    oled.writeString(font, 1, 'Out: ' + weather.current_observation.temp_f, 1, true);
    oled.setCursor(0+xoff, 24+yoff);
    oled.writeString(font, 1, 
        'lo:  ' + weather.forecast.simpleforecast.forecastday[0].low.fahrenheit, 1, true);
    oled.setCursor(0+xoff, 32+yoff);
    oled.writeString(font, 1, 
        'hi:  ' + weather.forecast.simpleforecast.forecastday[0].high.fahrenheit, 1, true);
    
    clearTimeout(timer);
    timer = setTimeout(off, timeOut);   // Only leave on for timeOut ms
});

function off () {
    // console.log("oled off...");
    oled.turnOffDisplay();
}

console.log("Ready...");