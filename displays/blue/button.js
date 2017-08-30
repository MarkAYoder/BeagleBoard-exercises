#!/usr/bin/env node
var b = require('bonescript');

var button = "PAUSE";
var LED    = "RED_LED";

b.pinMode(button, b.INPUT);
b.pinMode(LED, b.OUTPUT);


b.attachInterrupt(button, toggle, b.CHANGE);
console.log("Ready...");

function toggle(x) {
    b.digitalWrite(LED, x.value);
}
