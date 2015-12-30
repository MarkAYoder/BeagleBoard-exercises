#!/usr/bin/env node

var fs = require('fs');
var util = require('util');
var LEDs = "/sys/firmware/lpd8806/device/rgb";
var LEDcount = process.env.STRING_LEN;
var ms = 10;

console.log("LEDcount = %d", LEDcount);

var fd = fs.openSync(LEDs, 'w');
console.log("fd=%d", fd);

for(var i = 0; i < LEDcount; i++) {
    // fs.writeSync(fd, util.format("150 0 0 %d", i));
    fs.write(fd, util.format("0 50 0 %d", i), 0, 'utf8', function(err, written, string) {
        // console.log("written = %d", written);
    });
}

updateLED(0, 1, 0, LEDcount);

function updateLED(pos, dir, start, stop) {
    fs.write(fd, util.format("0 0 0 %d", pos), 0, 'utf8', function(err, written, string) {});
    // console.log("fd=%d", fd);
    // fs.writeSync(fd, util.format("0 0 0 %d", pos));
    console.log("pos=%d, dir=%d, start=%d, stop=%d", pos, dir, start, stop);
    pos += dir;
    if(pos >= stop || pos < start) {
        dir = -dir;
        pos += dir;
        console.log("dir = %d", dir);
    }
  fs.write(fd, util.format("0 150 0 %d\n", pos), 0, 'utf8', function(err, written, string) {});
    // fs.writeSync(fd, util.format("0 150 0 %d\n", pos));
    setTimeout(updateLED, ms, pos, dir, start, stop);
}

// function testMe(err, written, string) {
//     console.log("written = %d", written);
//     fs.closeSync(fd);
// }

fs.writeSync(fd, "\n");
// fs.closeSync(fd);