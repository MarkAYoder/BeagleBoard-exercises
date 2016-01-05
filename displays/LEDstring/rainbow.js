#!/usr/bin/env node

var fs = require('fs');
var util = require('util');
var LEDs = "/sys/firmware/lpd8806/device/rgb";
var LEDcount = process.env.STRING_LEN;
var ms = 50;

var amp = 25;
var f = 25;
var shift = 3;
var phase = 0;

// Open a file
console.log("LEDcount = %d", LEDcount);

var fd = fs.openSync(LEDs, 'w');
// console.log("fd=%d", fd);

setInterval(doRainbow, ms);
// doRainbow();

function doRainbow() {
    for(var i=0; i<LEDcount; i++) {
        var r = Math.floor(amp * (Math.sin(2*Math.PI*f*(i-phase-0*shift)/LEDcount) + 1)) + 1;
        var g = Math.floor(amp * (Math.sin(2*Math.PI*f*(i-phase-1*shift)/LEDcount) + 1)) + 1;
        var b = Math.floor(amp * (Math.sin(2*Math.PI*f*(i-phase-2*shift)/LEDcount) + 1)) + 1;
        fs.write(fd, util.format("%d %d %d %d ", r, g, b, i));
        // console.log(util.format("%d %d %d %d ", r, 0, 0, i));
    }

    fs.write(fd, "0 0 0 -1\n");
    phase++;
}
