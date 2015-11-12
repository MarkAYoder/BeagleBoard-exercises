#!/usr/bin/env node
//  SparkFun Soil Moisture Sensor https://www.sparkfun.com/products/13322
//  It's recomended that the device not be powered all the time,
//    so we'll use a GPIO pin to turn it on when we need it.

var b = require('bonescript');

var SOIL = 'P9_40';
var POWER = 'P9_41';
var ms = 2000;

b.pinMode(POWER, b.OUTPUT);

setInterval(powerOn, ms);

function powerOn() {
    b.digitalWrite(POWER, 1, readSoil);
}

function readSoil() {
    b.analogRead(SOIL, printSoil);
}

function printSoil(x) {
    b.digitalWrite(POWER, 0);
    console.log(x.value.toFixed(3));
}