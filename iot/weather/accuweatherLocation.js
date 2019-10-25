#!/usr/bin/env node
// Run the code to get the location code. Use it in other scripts.
// See https://developer.accuweather.com/apis 

const request = require('request');
const util    = require('util');

const apiKey = '6NqTqNvkopaCjP0JiQPEeKt7AJPcVCsk';
const zip = 47834;

const locationURL = util.format('http://dataservice.accuweather.com/' 
          + 'locations/v1/postalcodes/search?apikey=%s&q=%s',
        apiKey, zip);
// Look up location apiKey
request(locationURL, function (error, response, body) {
  if (!error && response.statusCode == 200) {
    const weather = JSON.parse(body)[0];
    // console.log(body);
    console.log('City: ' + weather.LocalizedName + ', ' 
        + weather.AdministrativeArea.LocalizedName); 
    console.log('LocationKey: ' + weather.ParentCity.Key); 
  } else {
    console.log("error=" + error + " response=" + JSON.stringify(response));
  }
});
