#!/usr/bin/env node
// Reads in two bytes of the matrix and toggles one bit.
// readBytes seems to only read one byte at a time, thus it called over and over

// Usage:  toggleByte x y
var i2c = require('i2c');

var bus = '/dev/i2c-2';
var matrix = 0x70;
var display = new i2c(matrix, {device: bus});

var x = 0;
var y = 0;
if(process.argv.length === 4) {
    x = process.argv[2];
    y = process.argv[3];
}

var i=0;
var line = [];
display.readBytes(2*x, 1, getValue);

function getValue(err, res) {
    if(err) {
        console.log("getValue: err: " + err);
    }
    line[i] = res[0];
    // console.log("res: %s", line[i].toString(16));
    i++;
    if(i<2) {
        display.readBytes(2*x+i, 1, getValue);
    } else {
        processData(line);
    }
}

function processData(line) {
    var i;
    // for(i=0; i<line.length; i+=2) {
    //     console.log("processData: %d:  %s, %s", i, line[i].toString(16), line[i+1].toString(16));
    // }
    line[0] ^= 1<<y;    // Toggle green LED
    line[1] ^= 1<<y;    // Toggle red LED
    
    // for(i=0; i<line.length; i+=2) {
    //     console.log("processData: %s, %s", line[i].toString(16), line[i+1].toString(16));
    // }
    
    display.writeBytes(2*x, line, done);
}

function done(err) {
    if(err) {
        console.log("done: err: " + err);
    }
}