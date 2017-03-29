#!/usr/bin/env node
// Flashes Cordwood LEDs https://www.boldport.com/products/cordwood-puzzle-second-edition/

var b = require('bonescript');

var leds = ["P8_8", "P8_10", "P8_12", "P8_14", "P8_16", "P8_18"];

for(var i in leds) {
    b.pinMode(leds[i], b.OUTPUT);
}

var state = 0;
for(var i in leds) {
    b.digitalWrite(leds[i], state);
}

setInterval(toggle, 100);

function toggle() {
    b.digitalWrite(leds[state], b.LOW);

    state++;
    if(state >= leds.length) {
        state = 0;
    }

    b.digitalWrite(leds[state], b.HIGH);
    
    // console.log("LED: ", leds[state]);
}
