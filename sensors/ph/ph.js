#!/usr/bin/env node
//  SparkFun Verier pH Sensor https://www.sparkfun.com/products/12872

var b = require('bonescript');

var SOIL = 'P9_40';
var ms = 2000;

setInterval(readSoil, ms);

function readSoil() {
    b.analogRead(SOIL, printSoil);
}

// The pH Sensor outputs a value between 0 and 5V.
// A voltage divider with a 3.3 and 1.8 K Ohm resistor scales that to under 1.8V,
//   which is the max the Beagle analog in can take.
// Multiply the value read by (3.3+1.8)/1.8 to get the voltage from the sensor
// A pH of 7 outputs 1.75V.  The reading decreases by .25V for every rise of 1 pH.
//  7-4(reading-1.75), convert to pH.
function printSoil(x) {
    console.log('ph: ' + (7-4*(5.1/1.8*x.value-1.75)).toFixed(2));
}