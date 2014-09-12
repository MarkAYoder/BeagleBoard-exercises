#!/usr/bin/env node
var b = require('bonescript');
var LED = 'P9_11';
var button = 'P9_12';
var state = b.HIGH;

b.pinMode(button, b.INPUT, 7, 'pulldown');
b.pinMode(LED, b.OUTPUT);

// b.attachInterrupt(button, true, b.CHANGE, blink);
setInterval(blink, 250)

function blink(){
    b.digitalWrite(LED, state);
    state = ~state;
}
