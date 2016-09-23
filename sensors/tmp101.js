#!/usr/bin/env node
// Reads the tmp101 temperature sensor.

var i2c = require('i2c-bus');
var bus = 2;
var tmp101 = [0x48, 0x49, 0x4a];
var time = 1000;    // Time between readings

var sensor = i2c.openSync(bus);

var temp = [];

for(var i=0; i<tmp101.length; i++) {
    temp[i] = sensor.readByteSync(tmp101[i], 0x0);
    console.log("temp: %dC, %dF (0x%s)", temp[i], temp[i]*9/5+32, tmp101[i].toString(16));
}
