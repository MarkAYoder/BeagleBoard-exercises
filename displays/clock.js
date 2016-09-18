#!/usr/bin/env node
// Displays a clock on the LED matrix
// Mark A. Yoder
// 17-Sept-2016

// npm install -g i2c-bus
var i2c = require('i2c-bus');
// var util = require('util');

var bus = 2;
var matrix = 0x70;
var display = i2c.openSync(bus);

// position maps index to a location around the outside of the display
// 0,0 is the bottom left.  Starts at top middle
position = new Array(28);
var i;
for(i=0; i<4; i++) {
    position[i]  = [i+4, 7];
}
for(; i<11; i++) {          // Head down the right side
    position[i] = [7, 11-i];
}
for(; i<18; i++) {          // Left across the bottom
    position[i] = [18-i, 0];
}
for(; i<25; i++) {          // Up the left side
    position[i] = [0, i-18];
}
for(; i<29; i++) {
    position[i] = [i-25, 7];
}

// console.log("position: " + util.inspect(position));

var last;   // index of bit that was just toggled

var interval = setInterval(update, 2000);  // update every 2 secs.  Only 28 LEDs to toggle

function update() {
    var seconds = new Date().getSeconds();
    var index = (seconds/60*28).toFixed(0);
    if(!isNaN(last)) {
        toggle(last);   // Undo the toggle from before
    }
    toggle(index);
    last = index;       // Remember what you toggled so you can undo it next time
}

function toggle(index) {
    var x = position[index][0];
    var y = position[index][1];
    // console.log("seconds: %d (%d)", seconds, index);
    // console.log("seconds: (%d, %d)", x, y);
    
    var line = new Buffer(2);
    line[0] = display.readByteSync(matrix, 2*x  );
    line[1] = display.readByteSync(matrix, 2*x+1);
    
    line[0] ^= 1<<y;
    line[1] ^= 1<<y;    
    
    display.writeI2cBlockSync(matrix, 2*x, line.length, line);  // You can write a whole line at once
}

process.on('SIGINT', function(code) {
    console.log("Exiting...");
    clearInterval(interval);
    toggle(last);
});
