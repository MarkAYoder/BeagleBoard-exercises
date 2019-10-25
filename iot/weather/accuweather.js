#!/usr/bin/env node
const request = require('request');
const util    = require('util');

const apiKey = '6NqTqNvkopaCjP0JiQPEeKt7AJPcVCsk';
const zip = 47834;
// Run the commented out code below to get the location code.  Assign it to location

// See https://developer.accuweather.com/apis for features
// try 'currentconditions', 'forecasts'
const feature = 'currentconditions';

const locationURL = util.format('http://dataservice.accuweather.com/locations/v1/postalcodes/search?apikey=%s&q=%s',
                        apiKey, zip);
// Look up location apiKey
// request(locationURL, function (error, response, body) {
//   if (!error && response.statusCode == 200) {
//     const weather = JSON.parse(body)[0];
//     // console.log(body);
//     console.log('City: ' + util.inspect(weather.LocalizedName)); 
//     location = weather.ParentCity.Key;
//     console.log('Key: ' + util.inspect(location)); 
//   } else {
//     console.log("error=" + error + " response=" + JSON.stringify(response));
//   }
// });

const location = '332887';  // Run the above code to get this value

// Look up conditions
const url = util.format('http://dataservice.accuweather.com/%s/v1/%s?apikey=%s',
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
