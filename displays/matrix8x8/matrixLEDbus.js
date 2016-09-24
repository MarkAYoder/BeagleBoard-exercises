#!/usr/bin/env node
// This is a workaround since the BoneScript i2c isn't working.
// This uses a different package than BoneScript.
// install:  npm install i2c-bus

var i2c = require('i2c-bus');
var bus = 2;
var matrix = 0x70;
var time = 1000; // Delay between images in ms

// The first byte is GREEN, the second is RED.
var smile = new Buffer([0x00, 0x3c, 0x00, 0x42, 0x28, 0x89, 0x04, 0x85,
    0x04, 0x85, 0x28, 0x89, 0x00, 0x42, 0x00, 0x3c
]);
var frown = new Buffer([0x3c, 0x00, 0x42, 0x00, 0x85, 0x20, 0x89, 0x00,
    0x89, 0x00, 0x85, 0x20, 0x42, 0x00, 0x3c, 0x00
]);
var neutral =new Buffer( [0x3c, 0x3c, 0x42, 0x42, 0xa9, 0xa9, 0x89, 0x89,
    0x89, 0x89, 0xa9, 0xa9, 0x42, 0x42, 0x3c, 0x3c
]);

var display = i2c.openSync(bus);

display.writeByteSync(matrix, 0x21, 0x01);   // Start oscillator (p10)
display.writeByteSync(matrix, 0x81, 0x01);   // Disp on, blink off (p11)
display.writeByteSync(matrix, 0xe7, 0x01);   // Full brightness (page 15)

setTimeout(doFrown,   0);
setTimeout(doNeutral, 1*time);
setTimeout(doSmile,   2*time);

function doFrown() {
   display.writeI2cBlockSync(matrix, 0x00, frown.length, frown);
}

function doNeutral() {
   display.writeI2cBlockSync(matrix, 0x00, neutral.length, neutral);
}

function doSmile() {
   display.writeI2cBlockSync(matrix, 0x00, smile.length, smile);
}
