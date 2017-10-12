#!/usr/bin/env node
// Displays temp and humidity and forcast from wunderground
// 
// Gets data from weather underground.
// Displays as
//  Temp:
//  Hum:
//  lo:
//  hi:
//      time
// Where Temp is the outdoor temp from wunderground and lo and hi are the 
//  forecasted low and hi temps.

var request = require('request');
var fs      = require('fs');
var util    = require('util'); 

// Get outdoor temp and forcast from wunderground
var urlWeather = "http://api.wunderground.com/api/ec7eb641373d9256/conditions/forecast/q/IN/Brazil.json";
request(urlWeather, {timeout: 10000}, function(err, res, body) {
    if(err) {
        console.log("err wunderground: " + err);
    }
    var weather = JSON.parse(body);
    console.log("Temp:%s, lo:%s, hi:%s",
            weather.current_observation.temp_f,
            weather.forecast.simpleforecast.forecastday[0].low.fahrenheit,
            weather.forecast.simpleforecast.forecastday[0].high.fahrenheit
            );
});

console.log("Ready...");