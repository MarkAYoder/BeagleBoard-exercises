#!/usr/bin/env node
// Flashes Cordwood LEDs https://www.boldport.com/products/cordwood-puzzle-second-edition/

console.log("Loading bonescript...");
var b = require('bonescript');
console.log("Done...");

var leds = ["P8_8", "P8_10", "P8_12", "P8_14", "P8_16", "P8_18"];

for(var i in leds) {
    b.pinMode(leds[i], b.OUTPUT);
}

var periodOn = 100;
var periodOff= 101;
var stateOn = 0;
var stateOff = leds.length/2;

for(var i in leds) {
    b.digitalWrite(leds[i], 0);
}

setInterval(on, periodOn);
setTimeout(startOff, 0);     // Start turning off 1/2 period later

function startOff() {
    setInterval(off, periodOff);
}

function on() {
    stateOn++;
    if(stateOn >= leds.length) {
        stateOn = 0;
    }
    b.digitalWrite(leds[stateOn], b.HIGH);
    
    // console.log("on: ", leds[stateOn]);
}

function off() {
    stateOff++;
    if(stateOff >= leds.length) {
        stateOff = 0;
    }

    b.digitalWrite(leds[stateOff], b.LOW);
    
    // console.log("off: ", leds[stateOff]);
}
