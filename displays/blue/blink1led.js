#!/usr/bin/env node
var b = require('bonescript');

var led = "USR0"; 

// Set direction to output
b.pinMode(led, b.OUTPUT);

// Turn LED off
var state = 0;
b.digitalWrite(led, state);

// Every 500ma call toggle()
setInterval(toggle, 500);

function toggle() {
    if(state == 0) {
        state = 1;
    } else {
        state = 0;
    }
    b.digitalWrite(led, state);
}
