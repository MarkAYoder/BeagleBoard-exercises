#!/usr/bin/env node
// From Blinks various LEDs
var Blynk = require('blynk-library');
var b = require('bonescript');
var util = require('util');

var LEDs = ['GP1_3', 'GP1_4', 'GREEN_LED', 'RED_LED'];
var button = 'GP0_5';
for(var i=0; i<LEDs.length; i++) {
    console.log("pinMode: " + i);
    b.pinMode(LEDs[i], b.OUTPUT);
}
b.pinMode(button, b.INPUT);

var AUTH = 'dc1c083949324ca28fbf393231f8cf09';

var blynk = new Blynk.Blynk(AUTH);

var v = new Array(LEDs.length);
for(i=0; i<LEDs.length; i++) {
    console.log("VirtualPin: " + i);
    v[i] = new blynk.VirtualPin(i);
}
var v10 = new blynk.WidgetLED(10);

for(i=0; i<LEDs.length; i++) {
    v[i].on('write', function(param) {
        console.log('V' + i + ':', param[0]);
        b.digitalWrite(LEDs[i], param[0]);
    });
}

v10.setValue(0);    // Initiallly off

b.attachInterrupt(button, toggle, b.CHANGE);

function toggle(x) {
    console.log("V10: ", x.value);
    x.value ? v10.turnOff() : v10.turnOn();
}
