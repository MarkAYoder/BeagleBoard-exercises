#!/usr/bin/env node
// Measure the humidity with SparkFun Humidity Sensor Breakout - HIH-4030
// https://www.sparkfun.com/products/9569
// Go to http://14.139.34.32:8080/streams/make and create a new stream
// Save the keys json file and copy to keys.json
// Run this script

var request       = require('request');
var util          = require('util');
var fs            = require('fs');
var b             = require('bonescript');
var humidPin = 'P9_40';     // Attach HIH-4030 here
var ms = 5*60*1000;               // Repeat time

var filename = "/home/yoder/exercises/phant/keys_humid.json";
var filename = "/root/exercises/phant/keys_humid.json";
// console.log("process.argv.length: " + process.argv.length);
if(process.argv.length === 3) {
    filename = process.argv[2];
}
var keys = JSON.parse(fs.readFileSync(filename));
console.log("Using: " + filename);
console.log("Title: " + keys.title);
// console.log(util.inspect(keys));

var urlBase = keys.inputUrl + "/?private_key=" + keys.privateKey + "&humidity=";

// Read humidity

setInterval(readHumidity, ms);

readHumidity();

function readHumidity() {
    b.analogRead(humidPin, postHumidity);
}

function postHumidity(x) {
    var url = urlBase + x.value.toFixed(4);
    if(x.err) {
        console.log('x.err = ' + x.err);
        console.log('x.value = ' + x.value);
        console.log("url: " + url);
    }

    console.log("value: " + x.value.toFixed(4));

    // Send the time to the phant server.
    request(url, function (error, response, body) {
        if (!error && response.statusCode == 200) {
            console.log(body); 
        } else {
            console.log("error=" + error + " response=" + JSON.stringify(response));
        }
    })
}