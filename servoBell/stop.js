#!/usr/bin/env node
// Used for turning everything off.
var b = require('bonescript');
var gpio = ['P9_11', 'P9_13', 'P9_14', 'P9_15', 'P9_16'];
var i;

for(i=0; i<gpio.length; i++) {
    b.pinMode(gpio[i], b.OUTPUT);
    b.digitalWrite(gpio[i], b.LOW);
}
