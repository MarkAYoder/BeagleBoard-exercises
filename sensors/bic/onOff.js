#!/usr/bin/env node
// Turns on OLED display for a set time

console.log("Loading bonescript...");
var b             = require('bonescript');
console.log("Loading oled-spi...");
var oledspi       = require('oled-spi');

var inputPin = 'P9_28';
var ms = 15*1000;       // On time

b.pinMode(inputPin, b.INPUT);

// spi options
var opts = {
    device: "/dev/spidev2.1",
    width:  128,
    height: 64,
    dcPin:  7,
    rstPin: 20
};
var oled = new oledspi(opts);

b.attachInterrupt(inputPin, true, b.FALLING, interruptCallback);

function interruptCallback() {
    // console.log("Callback");
    oled.turnOnDisplay();
    setTimeout(off, ms);
}

function off () {
    // console.log("off");
    oled.turnOffDisplay();
}
console.log("Ready...");
