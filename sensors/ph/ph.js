#!/usr/bin/env node
//  SparkFun Verier pH Sensor https://www.sparkfun.com/products/12872

var b = require('bonescript');

var SOIL = 'P9_36';
var ms = 40;
var data = [];
var i;
var MAXDATA = 50
for(i=0; i<MAXDATA; i++) {
    data[i] = 0.484;
}
var currentIndex = 0;

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
    if(x.err) {
        console.log('x: ' , x);
        return;
    }
    // console.log('\tvalue: ' + x.value);
    data[currentIndex++] = x.value;
    if(currentIndex>=MAXDATA) {
        currentIndex = 0;
        printPh();
    }
}

function printPh() {
    var sum=0;
    for(i=0; i<MAXDATA; i++) {
        sum += data[i];
    }
    var aveValue = sum/MAXDATA;
    console.log('aveValue: ' + aveValue);
    console.log('phAve: ' + (4-(6/0.289*(aveValue-0.474))).toFixed(1));
}
