#!/usr/bin/env node
// From Blinks various LEDs
var Blynk = require('blynk-library');
var b = require('bonescript');

var LED0 = 'GP1_3';
// var button = 'GP0_5';
b.pinMode(LED0, b.OUTPUT);
// b.pinMode(button, b.INPUT);

var AUTH = 'dc1c083949324ca28fbf393231f8cf09';

var blynk = new Blynk.Blynk(AUTH);

var v0 = new blynk.VirtualPin(0);
// var v1 = new blynk.VirtualPin(1);
// var v9 = new blynk.VirtualPin(9);

v0.on('write', function(param) {
    console.log('V0:', param[0]);
    b.digitalWrite(LED0, param[0]);
});

// v9.on('read', function() {
//     v9.write(new Date().getSeconds());
// });

// b.attachInterrupt(button, b.CHANGE, toggle);

// function toggle(x) {
//     console.log("V1: ", x.value);
//     // x.value ? v1.on() : v1.off();
// }
