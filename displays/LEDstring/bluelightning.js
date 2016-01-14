#!/usr/bin/env node

var fs = require('fs');
var util = require('util');
var LEDs = "/sys/firmware/lpd8806/device/rgb";
var LEDcount = process.env.STRING_LEN;
var ms = 50;
var colorUp = "50 0 0";
var colorDown = "0 50 50";
var colorUpOff = "0 0 0";
var colorDownOff= "0 0 25";

console.log("LEDcount = %d", LEDcount);

var fd = fs.openSync(LEDs, 'w');
console.log("fd=%d", fd);

for(var i = 0; i<10; i++) {
    console.log("i=%d", i);
    setTimeout(updateLED, 30*i*ms, {pos: 0, dir: 1, start: 0, stop: LEDcount, color: colorUp, colorOff: colorUpOff});
}
setInterval(updateString, ms);

function updateLED(x) {
    fs.write(fd, util.format("%s %d", x.colorOff, x.pos));
    x.pos += x.dir;
    if(x.pos >= x.stop || x.pos < x.start) {
        x.dir = -x.dir;
        x.pos += x.dir;
        if(x.dir>0) {
            x.color=colorUp;
            x.colorOff=colorUpOff;
        } else {
            x.color = colorDown;
            x.colorOff=colorDownOff;
        }
        console.log("dir = %d", x.dir);
    }
    fs.write(fd, util.format("%s %d", x.color, x.pos));
    setTimeout(updateLED, ms, x);
}

// Send \n to cause the string data to be written out.
function updateString() {
    fs.write(fd, "\n");
}

// Clean up with ^C is hit.
process.on('SIGINT', function() {
    console.log('\nGot SIGINT');
    process.exit();
    fs.closeSync(fd);
});