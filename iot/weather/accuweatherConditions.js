#!/usr/bin/env node
// Return Current conditions from accuweather.com
const request = require('request');
const util    = require('util');

const apiKey = '6NqTqNvkopaCjP0JiQPEeKt7AJPcVCsk';
// Run the commented out code below to get the location code.  Assign it to location

// See https://developer.accuweather.com/apis for features
// try 'currentconditions', 'forecasts'
const feature = 'currentconditions/v1';

// Run accuweatherLocation.js to get location key
const location = '332887'; 

// Look up conditions
const url = util.format('http://dataservice.accuweather.com/%s/%s?apikey=%s',
                        feature, location, apiKey);
// console.log(url);

request(url, function (error, response, body) {
  if (!error && response.statusCode == 200) {
    const weather = JSON.parse(body)[0];
    // console.log(body);
    console.log(util.format('%s: %s%s',
        weather.WeatherText,
        weather.Temperature.Imperial.Value,
        weather.Temperature.Imperial.Unit)); 
  } else {
    console.log("error=" + error + " response=" + JSON.stringify(response));
  }
});
