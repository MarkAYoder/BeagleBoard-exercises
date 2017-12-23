#!/usr/bin/env node
// From Blinks various LEDs
const Blynk = require('blynk-library');
const b = require('bonescript');
const util = require('util');
const exec = require('child_process').exec;
var fs = require('fs');
const LEDs = "/sys/firmware/lpd8806/device/rgb";
const LEDcount = process.env.STRING_LEN;

var fd = fs.openSync(LEDs, 'w');

const AUTH = 'dc1c083949324ca28fbf393231f8cf09';

var blynk = new Blynk.Blynk(AUTH);

var v4 = new blynk.VirtualPin(4);
var v10 = new blynk.WidgetLED(10);
// console.log(util.inspect(v1));
// var v9 = new blynk.VirtualPin(9);

v4.on('write', function(param) {
    var r = param[0];
    var g = param[1];
    var b = param[2];
    console.log(util.format("R: %d, G: %d, B: %d", r, g, b));
    for(var i=0; i<LEDcount; i++) {
        fs.write(fd, util.format("%d %d %d %d ", r, g, b, i));
    }
    // Update string
    fs.write(fd, util.format("\n"));

});

