#!/usr/bin/env node
const request = require('request');
const util    = require('util');

const apiKey = '6NqTqNvkopaCjP0JiQPEeKt7AJPcVCsk';
// See https://developer.accuweather.com/apis for features
// try forecasts'
const feature = 'forecasts/v1/daily/5day';

// Run accuweatherLocation.js to get location key
const locationKey = '332887';  // Run the above code to get this value

// Look up conditions
const url = util.format('http://dataservice.accuweather.com/%s/%s?apikey=%s',
                        feature, locationKey, apiKey);
// console.log(url);

request(url, function (error, response, body) {
  if (!error && response.statusCode == 200) {
    const weather = JSON.parse(body);
    // console.log(body);
    for(var i=0; i<weather.DailyForecasts.length; i++) {
      var forecast = weather.DailyForecasts[i];
      console.log(util.format('Day: %s: Min: %d, Max: %s, Night: %s, %s',
          forecast.Day.IconPhrase,
          forecast.Temperature.Minimum.Value, forecast.Temperature.Maximum.Value,
          forecast.Night.IconPhrase, forecast.Night.PrecipitationIntensity, 
          )); 
    }
  } else {
    console.log("error=" + error + " response=" + JSON.stringify(response));
  }
});
