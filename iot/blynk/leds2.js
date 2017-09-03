#!/usr/bin/env node
// From Blinks various LEDs
var Blynk = require('blynk-library');
var b = require('bonescript');
var util = require('util');

var LEDs = ['GP1_3', 'GP1_4', 'GREEN_LED', 'RED_LED'];
var button = 'GP0_5';

var i;
for(i=0; i<LEDs.length; i++) {
    console.log("pinMode: " + i);
    b.pinMode(LEDs[i], b.OUTPUT);
}
b.pinMode(button, b.INPUT);

var AUTH = 'dc1c083949324ca28fbf393231f8cf09';

var blynk = new Blynk.Blynk(AUTH);

var v;
for(i=0; i<LEDs.length; i++) {
    console.log("VirtualPin: " + i);
    v = new blynk.VirtualPin(i);
    console.log(util.inspect(v));
    v.on('write', function(param) {
        console.log(util.inspect(param));
        console.log('V' + i + ':', param[0]);  // This part doesn't work since i isn't evaluated at the right time
        b.digitalWrite(LEDs[i], param[0]);
    });
}

var v10 = new blynk.WidgetLED(10);

v10.setValue(0);    // Initiallly off
b.attachInterrupt(button, toggle, b.CHANGE);

function toggle(x) {
    console.log("V10: ", x.value);
    x.value ? v10.turnOff() : v10.turnOn();
}
