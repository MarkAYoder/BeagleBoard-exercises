#!/usr/bin/env node

var fs = require('fs');
var util = require('util');
var LEDs = "/sys/firmware/lpd8806/device/rgb";
var LEDcount = process.env.STRING_LEN;

console.log("LEDcount = %d", LEDcount);

var fd = fs.openSync(LEDs, 'w');
console.log("fd=%d", fd);

for(var i = 0; i < LEDcount; i++) {
    // fs.writeSync(fd, util.format("150 50 50 %d", i));
    fs.write(fd, util.format("150 150 50 %d", i), 0, 'utf8', function(err, written, string) {
        // console.log("written = %d", written);
    });
}


// function testMe(err, written, string) {
//     console.log("written = %d", written);
//     fs.closeSync(fd);
// }

fs.writeSync(fd, "\n");
fs.closeSync(fd);