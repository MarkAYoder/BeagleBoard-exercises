#!/usr/bin/env node
// Flashes Cordwood LEDs https://www.boldport.com/products/cordwood-puzzle-second-edition/

var b = require('bonescript');

var leds = ["P8_7", "P8_8", "P8_10", "P8_12", "P8_14", "P8_16", "P8_18", "P8_19"];

for(var i in leds) {
    b.pinMode(leds[i], b.OUTPUT);
}

var state = b.LOW;
for(var i in leds) {
    b.digitalWrite(leds[i], state);
}

setInterval(toggle, 1000);

function toggle() {
    if(state == b.LOW) state = b.HIGH;
    else state = b.LOW;
    for(var i in leds) {
        b.digitalWrite(leds[i], state);
    }
    console.log("State: ", state);
}
