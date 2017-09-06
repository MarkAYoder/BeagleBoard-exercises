#!/usr/bin/env node
// Turns on LEDs and GP pins in sequence on Blue
var b = require('bonescript');

var leds = ["USR0", "USR1", "USR2", "USR3", 
            "GP0_4", "GP0_5", "GP0_6",
            "GP1_3", "GP1_4",
            "RED", "GREEN"
            ];
var input = "GP0_3";
var currentLED = 0;

b.pinMode(input, b.INPUT);

for(var i in leds) {
    b.pinMode(leds[i], b.OUTPUT);
}

for(var i in leds) {
    b.digitalWrite(leds[i], 0);
}
b.digitalWrite(leds[currentLED], 1);

b.attachInterrupt(input, nextLED, b.CHANGE);

console.log("Ready");

function nextLED(x) {
    b.digitalWrite(leds[currentLED], 0);
    currentLED++;
    if(currentLED >= leds.length) {
        currentLED = 0;
    }
    b.digitalWrite(leds[currentLED], 1);
}