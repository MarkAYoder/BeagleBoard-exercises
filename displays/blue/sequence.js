#!/usr/bin/env node
// Turns on LEDs and GP pins in sequence on Blue
var b = require('bonescript');

var LEDs = ["USR0", "USR1", "USR2", "USR3", 
            // "GP0_4", "GP0_5", "GP0_6",
            // "GP1_3", 
            "GP1_4",
            "bat25", "bat50", "bat75", "bat100", 
            "RED", "GREEN"
            ];
var input = "GP1_3";
var currentLED = 0;

b.pinMode(input, b.INPUT);

for(var i in LEDs) {
    b.pinMode(LEDs[i], b.OUTPUT);
}

for(var i in LEDs) {
    b.digitalWrite(LEDs[i], 0);
}
b.digitalWrite(LEDs[currentLED], 1);

b.attachInterrupt(input, nextLED, b.CHANGE);

console.log("Ready");

function nextLED(x) {
    b.digitalWrite(LEDs[currentLED], 0);
    currentLED++;
    if(currentLED >= LEDs.length) {
        currentLED = 0;
    }
    b.digitalWrite(LEDs[currentLED], 1);
}