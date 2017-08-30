#!/usr/bin/env node
var b = require('bonescript');

var leds = ["USR0", "USR1", "USR2", "USR3", 
            "GP0_3", "GP0_4", "GP0_5", "GP0_6",
            "GP1_3", "GP1_4",
            "RED_LED", "GREEN_LED"
            ];

for(var i in leds) {
    b.pinMode(leds[i], b.OUTPUT);
}

var state = b.LOW;
for(var i in leds) {
    b.digitalWrite(leds[i], state);
}

setInterval(toggle, 500);

function toggle() {
    if(state == b.LOW) state = b.HIGH;
    else state = b.LOW;
    for(var i in leds) {
        b.digitalWrite(leds[i], state);
    }
}
