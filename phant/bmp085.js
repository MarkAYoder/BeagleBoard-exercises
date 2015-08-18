#!/usr/bin/env node
// Read BMP085 temperature and pressure
// https://www.npmjs.com/package/bmp085
// npm install -g bmp085

var BMP085 = require('bmp085'),
    barometer = new BMP085();
 
barometer.read(function (data) {
    console.log("Temperature:", data.temperature);
    console.log("Pressure:", data.pressure);
});