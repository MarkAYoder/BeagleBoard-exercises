#!/usr/bin/env node
// npm install -g i2c

var b = require('bonescript');
// var i2c = require('i2c');
var port = '/dev/i2c-2'
var TMP102 = 0x70;
var time = 500; // Delay between images.

// The first btye is RED, the second is GREEN.
// The single color display responds only to the lower byte
var smile =
	[0x00, 0x3c, 0x00, 0x42, 0x28, 0x89, 0x04, 0x85, 
	 0x04, 0x85, 0x28, 0x89, 0x00, 0x42, 0x00, 0x3c];
var frown =
	[0x3c, 0x00, 0x42, 0x00, 0x85, 0x20, 0x89, 0x00, 
	 0x89, 0x00, 0x85, 0x20, 0x42, 0x00, 0x3c, 0x00];
var neutral =
	[0x3c, 0x3c, 0x42, 0x42, 0xa9, 0xa9, 0x89, 0x89,
	 0x89, 0x89, 0xa9, 0xa9, 0x42, 0x42, 0x3c, 0x3c];
var blank = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

b.i2cOpen(port, TMP102, {}, onI2C);

function onI2C(x) {
    var bytes = [2, 7];
    if (x.event == 'return') {
        // b.i2cReadByte(port, onReadByte);
        b.i2cWriteBytes(port, 0x00, neutral);
        setTimeout(function() {
            b.i2cWriteBytes(port, 0x00, smile);
        }, time);
    }
}

function onReadByte(x) {
    if (x.event == 'callback') {
        console.log('onReadByte: ' + JSON.stringify(x));
    }
}
