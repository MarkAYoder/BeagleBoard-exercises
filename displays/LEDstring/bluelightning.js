#!/usr/bin/env node

var fs = require('fs');
var util = require('util');
var LEDs = "/sys/firmware/lpd8806/device/rgb";
var LEDcount = process.env.STRING_LEN;
var ms = 50;
var colorUp = "50 0 0";
var colorDown = "0 0 50";
var colorOff = "0 0 0";

console.log("LEDcount = %d", LEDcount);

var fd = fs.openSync(LEDs, 'w');
console.log("fd=%d", fd);

// for(var i = 0; i < LEDcount; i++) {
//     // fs.writeSync(fd, util.format("150 0 0 %d", i));
//     fs.write(fd, util.format("0 50 0 %d", i));
// }

for(var i = 0; i<100; i+=10) {
    console.log("i=%d", i);
    setTimeout(updateLED, i*ms, 0, 1, 0, LEDcount, colorUp);
}

function updateLED(pos, dir, start, stop, color) {
    fs.write(fd, util.format("%s %d", colorOff, pos));
    // console.log("fd=%d", fd);
    // fs.writeSync(fd, util.format("0 0 0 %d", pos));
    // console.log("pos=%d, dir=%d, start=%d, stop=%d", pos, dir, start, stop);
    pos += dir;
    if(pos >= stop || pos < start) {
        dir = -dir;
        pos += dir;
        if(dir>0) {
            color=colorUp;
        } else {
            color = colorDown;
        }
        console.log("dir = %d", dir);
    }
  fs.write(fd, util.format("%s %d\n", color, pos), 0, 'utf8', function(err, written, string) {});
    // fs.writeSync(fd, util.format("0 150 0 %d\n", pos));
    setTimeout(updateLED, ms, pos, dir, start, stop, color);
}

// fs.writeSync(fd, "\n");
// fs.closeSync(fd);