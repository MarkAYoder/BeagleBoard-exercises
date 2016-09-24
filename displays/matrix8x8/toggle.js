#!/usr/bin/env node
// Reads in whole matrix and toggles one bit.
// readBytes seems to only read one byte at a time, thus it called over and over
// Uses 2ic-bus
// Usage:  toggle.js x y
var i2c = require('i2c-bus');

var bus = 2;
var matrix = 0x70;
var display = i2c.openSync(bus);

var line = new Buffer(2);

var x = 0;
var y = 0;
if(process.argv.length === 4) {
    x = process.argv[2];
    y = process.argv[3];
    console.log("x: %d, y: %d", x, y);
}

line[0] = display.readByteSync(matrix, 2*x);    // green
line[1] = display.readByteSync(matrix, 2*x+1);  // red

line[0] ^= 1<<y;    // toggle the y-th bit
line[1] ^= 1<<y;
    
display.writeI2cBlockSync(matrix, 2*x, line.length, line);  // You can write a whole line at once
