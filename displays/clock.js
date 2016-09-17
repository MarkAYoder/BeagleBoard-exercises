#!/usr/bin/env node
// Displays a clock on the LED matrix
// Mark A. Yoder
// 17-Sept-2016

var i2c = require('i2c');
var util = require('util');
var exec = require('child_process').exec;

var bus = '/dev/i2c-2';
var matrix = 0x70;
var display = new i2c(matrix, {device: bus});

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

toggleSeconds();
var last = 0;
function toggleSeconds() {
    var seconds = new Date().getSeconds();
    var index = (seconds/60*28).toFixed(0);
    
    console.log("seconds: %d (%d)", seconds, index);
    console.log("seconds: (%d, %d)", position[index][0], position[index][1]);
    exec("./toggleByte.js " +  position[index][0] + ' ' + position[index][1]);
}
