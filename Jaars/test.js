#!/usr/bin/env node
// For testing the the Jaars data collection cape

var b = require('bonescript');
var sleep = require('sleep');

var pins = ['P9_12', 'P9_14', 'P9_16', 'P9_18', 'P9_22'];
var enable = 'P9_16';
var analogIn = 'P9_40';

var headers = 4;
var pairs = 4;

for(var i=0; i<pins.length; i++) {
    // console.log(pins[i]);
    b.pinMode(pins[i], b.OUTPUT);
}

// Enable muxes
b.digitalWrite(enable, 1);
var value = [];  // Analog value read
value[15] = 0;
var err;    // Value returned by digitWrite so that it runs synchorously

for(var k=0; k<100; k++) {
    for(var i=0; i<headers; i++) {
        // console.log("header: " + i);
        err = b.digitalWrite('P9_12', (i>>1) & 0x1);
        err = b.digitalWrite('P9_14',  i     & 0x1);
        // b.digitalWrite('P9_12', 0);
        // b.digitalWrite('P9_14', 0);
        // console.log("bits: " + (i & 0x1) + (i>>1 & 0x1));
        for(var j=0; j<pairs; j++) {
            // console.log("pair: " + j);
            err = b.digitalWrite('P9_18', j & 0x1);
            err = b.digitalWrite('P9_22', (j>>1) & 0x1);
            // b.digitalWrite('P9_18', 0);
            // b.digitalWrite('P9_22', 0);
            value[4*i+j] = 1000*1.8*b.analogRead(analogIn);
            // console.log("value: %d", value[4*i+j]);
            sleep.usleep(100000);
            }
    }
    // console.log(" " + value);
    for(ll=0; ll<value.length; ll++) {
        process.stdout.write(value[ll].toFixed(2) + ", ");
    }
    process.stdout.write("\n");
    
    sleep.sleep(4);
}