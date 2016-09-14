#!/usr/bin/env node
// This is a workaround since the BoneScript i2c isn't working.
// Thanks to Ricky Rung
// install:  npm install i2c@0.2.1  (the latest version doesn't work)

var i2c = require('i2c');
var port = '/dev/i2c-2';
var matrix = 0x70;
var time = 1000; // Delay between images in ms

// The first byte is GREEN, the second is RED.
var smile = [0x00, 0x3c, 0x00, 0x42, 0x28, 0x89, 0x04, 0x85,
    0x04, 0x85, 0x28, 0x89, 0x00, 0x42, 0x00, 0x3c
];
var frown = [0x3c, 0x00, 0x42, 0x00, 0x85, 0x20, 0x89, 0x00,
    0x89, 0x00, 0x85, 0x20, 0x42, 0x00, 0x3c, 0x00
];
var neutral = [0x3c, 0x3c, 0x42, 0x42, 0xa9, 0xa9, 0x89, 0x89,
    0x89, 0x89, 0xa9, 0xa9, 0x42, 0x42, 0x3c, 0x3c
];

var wire = new i2c(0x70, {
    device: '/dev/i2c-2'
});
 
wire.writeByte(0x21, function(err) {            // Start oscillator (p10)
    wire.writeByte(0x81, function(err) {        // Disp on, blink off (p11)
        wire.writeByte(0xe7, function(err) {    // Full brightness (page 15)
            setTimeout(doFrown, 0);
            setTimeout(doNeutral, 1 * time);
            setTimeout(doSmile, 2 * time);
        });
    });
});

function doFrown() {
    wire.writeBytes(0x00, frown, function(err) {
    });
}

function doNeutral() {
    wire.writeBytes(0x00, neutral, function(err) {
    });
}

function doSmile() {
    wire.writeBytes(0x00, smile, function(err) {
    });
}
