#!/usr/bin/env node
// This tests how fast a gpio pin can be toggled
// Mark A. Yoder 31-May-2013

var b = require('bonescript');

var gpioPin = "P9_12";

b.pinMode(gpioPin, b.OUTPUT);

var state = b.LOW;
b.digitalWrite(gpioPin, state);

setInterval(toggle, 0.1);

function toggle() {
    if(state == b.LOW) state = b.HIGH;
    else state = b.LOW;
    b.digitalWrite(gpioPin, state);
}
