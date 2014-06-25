#!/usr/bin/env node
var b = require('bonescript');
var colors = require('colors');
var motor = 'P9_21';    // Pin to use
var freq = 50;   // Servo frequency (20 ms)
var dir = 0.01, // Direction
    min = 0.04,  // Smallest angle
    max = 0.2,   // Largest angle
    ms  = 250,    // How often to change position, in ms
    pos = min;  // Current position;

b.pinMode(motor, b.ANALOG_OUTPUT);

setTimeout(function () {move(0.05)} , 0);
setTimeout(function () {move(0.08)} , 5);

function move(pos) {

    dutyCycle = pos/1000*freq
    b.analogWrite(motor, pos, freq);
    console.log('pos = '.green + pos + ' duty cycle = '.red + dutyCycle);
}