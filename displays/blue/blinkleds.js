#!/usr/bin/env node
var b = require('bonescript');

var leds = ["USR0",  "USR1",  "USR2",  "USR3", 
            // "GP0_3", 
            "GP0_4",
            "GP0_5", "GP0_6",
            "GP1_3", "GP1_4",
            "RED", "GREEN"
            ];
// var leds = ["USR0", "USR1", "USR2", "USR3"];

for(var i in leds) {
    b.pinMode(leds[i], b.OUTPUT);
}

var state = 0;
for(var i in leds) {
    b.digitalWrite(leds[i], state);
}

setInterval(toggle, 500);

function toggle() {
    if(state == 0) state = 1;
    else state = 0;
    for(var i in leds) {
        b.digitalWrite(leds[i], state);
    }
}
