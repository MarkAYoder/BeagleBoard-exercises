#!/usr/bin/env node
// Code for drving an 8 by 8 LED Matrix
// Responds to button pushes
// http://www.adafruit.com/products/902
// BoneScript API: https://github.com/jadonk/bonescript
// Mark A. Yoder, 31-Aug-2015

var b = require('bonescript');
var port = '/dev/i2c-2'
var matrix = 0x70;
var time = 500; // Delay between images in ms

var button = "P9_42";			// This button sequences through the images
var button2 = "P9_18";			// This button fades out and in
b.pinMode(button, b.INPUT);
b.pinMode(button2, b.INPUT);

// The first byte is GREEN, the second is RED.
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

b.i2cOpen(port, matrix);

b.i2cWriteByte(port,  0x21); // Start oscillator (p10)
b.i2cWriteByte(port,  0x81); // Disp on, blink off (p11)
b.i2cWriteByte(port,  0xe7); // Full brightness (page 15)

b.attachInterrupt(button, true, b.FALLING, doSequence);

function doSequence() {
	doFrown();
	setTimeout(doNeutral, 1*time);
	setTimeout(doSmile, 2*time);
}

function doFrown() {
	b.i2cWriteBytes(port, 0x00, frown);
}

function doNeutral() {
	b.i2cWriteBytes(port, 0x00, neutral);
}

function doSmile() {
	b.i2cWriteBytes(port, 0x00, smile);
}

// Fade the display
b.attachInterrupt(button2, true, b.FALLING, doFadeDown);

var fade = 0xef;
doFadeDown();
function doFadeDown() {
    b.i2cWriteByte(port,  fade);
	fade--;
	if(fade >= 0xe0) {
		setTimeout(doFadeDown, time/10);
	} else {
		setTimeout(doFadeUp);
	}
}
function doFadeUp() {
    b.i2cWriteByte(port,  fade);
	fade++;
	if(fade <= 0xef) {
		setTimeout(doFadeUp, time/10);
	}
}
