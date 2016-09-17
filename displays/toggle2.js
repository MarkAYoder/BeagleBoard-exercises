#!/usr/bin/env node
// Reads in whole matrix and toggles one bit.
// readBytes seems to only read one byte at a time, thus it called over and over
// Uses 2ic-bus
var i2c = require('i2c-bus');
var util = require('util');

var bus = 2;
var matrix = 0x70;
var display = i2c.openSync(bus);
var length = 16;
var data = new Buffer(length);

var x = 1;
var y = 4;

var i;
var line = new Buffer(length);
for(i=0; i<length; i++) {
    line[i] = display.readByteSync(matrix, i);
    // console.log("read1: %d: " + read1.toString(16), i);
}

processData(line);

function processData(line) {
    var i;
    // for(i=0; i<line.length; i+=2) {
    //     console.log("processData: %d:  %s, %s", i, line[i].toString(16), line[i+1].toString(16));
    // }
    line[2*x]   ^= 1<<y;
    line[2*x+1] ^= 1<<y;
    
    // for(i=0; i<line.length; i+=2) {
    //     console.log("processData: %s, %s", line[i].toString(16), line[i+1].toString(16));
    // }
    display.writeI2cBlockSync(matrix, 0x0, line.length, line);  // You can write a whole line at once
}

function done(err) {
    if(err) {
        console.log("done: err: " + err);
    }
}