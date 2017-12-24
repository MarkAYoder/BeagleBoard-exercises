#!/usr/bin/env node
// From Blinks various LEDs
const Blynk = require('blynk-library');
const util = require('util');
const exec = require('child_process').exec;
var fs = require('fs');
const LEDs = "/sys/firmware/lpd8806/device/rgb";
const LEDcount = process.env.STRING_LEN;
const snowballTime=25;  // time between steps for snowballs

var fd = fs.openSync(LEDs, 'w');

const AUTH = 'dc1c083949324ca28fbf393231f8cf09';

var blynk = new Blynk.Blynk(AUTH);

var v0 = new blynk.VirtualPin(0);   // Left button, fire!
var v1 = new blynk.VirtualPin(1);   // Right button
var v4 = new blynk.VirtualPin(4);   // Color picker
var v5 = new blynk.VirtualPin(5);   // Color slider
var v6 = new blynk.VirtualPin(6);
var v7 = new blynk.VirtualPin(7);
var v8 = new blynk.VirtualPin(8);   // Scale slider

function display(r, g, b, idx) {
    //If iddx isn't given, update the whole string
    if(typeof idx === 'undefined') {
        console.log(util.format("R: %d, G: %d, B: %d, idx: %d", r, g, b, idx));
        for(var i=0; i<LEDcount; i++) {
            fs.write(fd, util.format("%d %d %d %d ", r>>scale, g>>scale, b>>scale, i));
        }
    } else {
        fs.write(fd, util.format("%d %d %d %d ", r>>scale, g>>scale, b>>scale, idx));
    }
    // Update string, assume others are updating
    // fs.write(fd, util.format("\n"));
}

function fire(r, g, b, current, stop, ms) {
    // console.log("fire! " + current);
    display(0, 0, 0, current);
    current++;
    if(current < stop) {
        display(r, g, b, current);
        setTimeout(fire, ms, r, g, b, current, stop, ms);
    }
}

// var v10 = new blynk.WidgetLED(10);
// console.log(util.inspect(v1));
// var v9 = new blynk.VirtualPin(9);

var r = 128;    // Color
var g = 128;
var b = 128;
var scale = 6;
// console.log("Blynk: " + util.inspect(Blynk));

v4.on('write', function(param) {
    r = param[0];
    g = param[1];
    b = param[2];
    display(r, g, b);
});

// Snowball, white
v0.on('write', function(param) {
    console.log('fire: ', param[0]);
    if(param[0]==='1') {
        fire(255, 255, 255, 0, LEDcount, snowballTime);
    }
});
v1.on('write', function(param) {
    console.log('fire color: ', param[0]);
    if(param[0]==='1') {
        fire(r, g, b, 0, LEDcount, snowballTime);
    }
});
v5.on('write', function(param) {
    console.log('Red: ', param[0]);
    r = param[0];
    display(r, g, b);
});
v6.on('write', function(param) {
    console.log('Green: ', param[0]);
    g = param[0];
    display(r, g, b);
});
v7.on('write', function(param) {
    console.log('Blue: ', param[0]);
    b = param[0];
    display(r, g, b);
});
v8.on('write', function(param) {
    console.log('Scale: ', param[0]);
    scale = param[0];
    display(r, g, b);
});
