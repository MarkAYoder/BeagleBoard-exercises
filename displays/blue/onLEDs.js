#!/usr/bin/env node
var b = require('bonescript');

var leds = ["USR0",  "USR1",  "USR2",  "USR3", 
            "GP0_3", "GP0_4", "GP0_5", "GP0_6",
            "GP1_3", "GP1_4",
            "BAT25", "BAT50", "BAT75", "BAT100",
            "RED", "GREEN",
            "WIFI"
            ];
var i;
for(i in leds) {
    b.pinMode(leds[i], b.OUTPUT);
    b.digitalWrite(leds[i], 1);
}
