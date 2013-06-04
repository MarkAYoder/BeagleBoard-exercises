// Tests the rotary encoder function

var b = require('bonescript');
var pinA = 'P9_30',
    pinB = 'P9_27';
    
var x = require('./readRotaryEncoder.js');

x.readRotaryEncoder(pinA, pinB, CWcallback, CCWcallback);

function CWcallback() {
    console.log('Turned CW');
}

function CCWcallback() {
    console.log('Turned CCW');
}

setTimeout(detach, 20000);

function detach() {
 b.detachInterrupt(pinA);
 b.detachInterrupt(pinB);
 console.log("All Done!");
}