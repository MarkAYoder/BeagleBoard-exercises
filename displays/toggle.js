#!/usr/bin/env node
/*jshint curly:true, debug:true */
var i2c = require('i2c');
var util = require('util');

var bus = '/dev/i2c-2';
var matrix = 0x70;
var display = new i2c(matrix, {device: bus});

var x = 1;
var y = 4;

var i=0;
var line = [];
display.readBytes(i, 1, getValue);

function getValue(err, res) {
    if(err) {
        console.log("getValue: err: " + err);
    }
    // var i;
    // for(i=0; i<res.length; i+=2) {
    //     console.log("%d: %s, %s", i, res[i].toString(16), res[i+1].toString(16));
    // }
    line[i] = res[0];
    // console.log("res: %s", line[i].toString(16));
    i++;
    if(i<16) {
        display.readBytes(i, 1, getValue);
    } else {
        processData(line);
    }
}

function processData(line) {
    var i;
    for(i=0; i<line.length; i+=2) {
        console.log("processData: %d:  %s, %s", i, line[i].toString(16), line[i+1].toString(16));
    }
    line[2*x]   ^= 1<<y;
    line[2*x+1] ^= 1<<y;
    
    for(i=0; i<line.length; i+=2) {
        console.log("processData: %s, %s", line[i].toString(16), line[i+1].toString(16));
    }
    
    display.writeBytes(0, line, done);
}

function done(err) {
    if(err) {
        console.log("done: err: " + err);
    }
}