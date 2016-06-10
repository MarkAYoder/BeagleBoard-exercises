#!/usr/bin/env node
var b = require('bonescript');

var leds = ["USR3", "P9_12", "P9_14", "P9_16", "P9_18", "P9_22", "P9_24", "P9_26", "P9_30",
     "P9_11", "P9_13", "P9_15", "P9_17", "P9_21", "P9_23", "P9_27"];

for(var i in leds) {
    b.pinMode(leds[i], b.OUTPUT);
}

var state = b.LOW;
for(var i in leds) {
    b.digitalWrite(leds[i], state);
}

setInterval(toggle, 10);

function toggle() {
    if(state == b.LOW) state = b.HIGH;
    else state = b.LOW;
    for(var i in leds) {
        b.digitalWrite(leds[i], state);
    }
}
