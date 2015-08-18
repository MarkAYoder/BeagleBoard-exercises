#!/usr/bin/env node
// Measure the weather
//      humidity with SparkFun Humidity Sensor Breakout - HIH-4030
//          https://www.sparkfun.com/products/9569
//      Barometric presure and temperature with BMP085
//          https://www.sparkfun.com/products/retired/11282

// Go to http://14.139.34.32:8080/streams/make and create a new stream
// Save the keys json file and copy to keys.json
// Run this script

var request       = require('request');
var BMP085        = require('bmp085');
var util          = require('util');
var fs            = require('fs');
var b             = require('bonescript');
var humidPin = 'P9_40';     // Attach HIH-4030 here
var ms = 60*1000;               // Repeat time

var filename = "/home/yoder/exercises/phant/keys_weather.json";
var filename = "/root/exercises/phant/keys_weather.json";
// console.log("process.argv.length: " + process.argv.length);
if(process.argv.length === 3) {
    filename = process.argv[2];
}
var keys = JSON.parse(fs.readFileSync(filename));
console.log("Using: " + filename);
console.log("Title: " + keys.title);
// console.log(util.inspect(keys));

var urlBase = keys.inputUrl + "/?private_key=" + keys.privateKey + "&humidity=%s&pressure=%s&temp=%s";

// Read 

var temp, pressure, humidity;
var barometer = new BMP085();

setInterval(readWeather, ms);

readWeather();

function readWeather() {
    barometer.read(postTemp);
    b.analogRead(humidPin, postHumidity);
}

function postHumidity(x) {
    humidity = x.value.toFixed(4);
    if(x.err) {
        console.log('x.err = ' + x.err);
        console.log('x.value = ' + x.value);
        console.log("url: " + url);
    }

    // console.log("humidity: " + humidity);
    
    if(temp) {      // Wait until both the humidity and temp have reported back.
        postWeather();
    } else {
        console.log("Waiting for temp");
    }
}

function postTemp(data) {
    // console.log("data: " + util.inspect(data));
    temp = data.temperature;
    pressure = data.pressure.toFixed(1);

    // console.log("temp: " + temp);
    // console.log("pressure: " + pressure);
    
    if(humidity) {      // Wait until both the humidity and temp have reported back.
        postWeather();
    } else {
        console.log("Waiting for humidity");
    }
}

function postWeather() {
    // Both temp and humidity have replied
    var url = util.format(urlBase, humidity, pressure, temp);
    // console.log("url: ", url);
    request(url, function (error, response, body) {
        if (!error && response.statusCode == 200) {
            console.log(body); 
        } else {
            console.log("error=" + error + " response=" + JSON.stringify(response));
        }
    })
    // Reset variables for next time.
    temp = '';
    pressure = '';
    humidity = '';
}