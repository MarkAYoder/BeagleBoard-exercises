#!/usr/bin/env node
// From Blinks various LEDs
const Blynk = require('blynk-library');
const b = require('bonescript');
const util = require('util');
const exec = require('child_process').exec;
const framebuffer = "../../displays/ili9341/framebuffer";

const LED0 = 'GREEN';
const button = 'GP1_3';
b.pinMode(LED0, b.OUTPUT);
b.pinMode(button, b.INPUT);

const AUTH = 'dc1c083949324ca28fbf393231f8cf09';

var blynk = new Blynk.Blynk(AUTH);

var v4 = new blynk.VirtualPin(4);
var v10 = new blynk.WidgetLED(10);
// console.log(util.inspect(v1));
// var v9 = new blynk.VirtualPin(9);

v4.on('write', function(param) {
    var r = param[0]/1023*31;
    var g = param[1]/1023*63;
    var b = param[2]/1023*31;
    console.log(util.format("R: %d, G: %d, B: %d", r, g, b));
    exec(util.format("%s %d %d %d", framebuffer, r, g, b), (error, stdout, stderr) => {
        if (error) {
            console.error(`exec error: ${error}`);
            return;
          }
    //   console.log(`stdout: ${stdout}`);
    //   console.log(`stderr: ${stderr}`);
    });
});

v10.setValue(0);    // Initiallly off

// v9.on('read', function() {
//     v9.write(new Date().getSeconds());
// });

b.attachInterrupt(button, toggle, b.CHANGE);

function toggle(x) {
    console.log("V1: ", x.value);
    x.value ? v10.turnOff() : v10.turnOn();
}
