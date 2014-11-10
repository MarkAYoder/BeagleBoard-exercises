#!/usr/bin/env node
// npm install -g sleep

var b = require('bonescript');
var sleep = require('sleep');
var port = '/dev/i2c-2'
var TMP102 = 0x70;
var time = 1000000; // Delay between images in us

// The first btye is GREEN, the second is RED.
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

b.i2cOpen(port, TMP102);

b.i2cWriteByte(port,  0x21); // Start oscillator (p10)
b.i2cWriteByte(port,  0x81); // Disp on, blink off (p11)
b.i2cWriteByte(port,  0xe7); // Full brightness (page 15)

b.i2cWriteBytes(port, 0x00, frown);
sleep.usleep(time);

b.i2cWriteBytes(port, 0x00, neutral);
sleep.usleep(time);

b.i2cWriteBytes(port, 0x00, smile);
// Fade the display
var fade;
for(fade = 0xef; fade >= 0xe0; fade--) {
    b.i2cWriteByte(port,  fade);
    sleep.usleep(time/10);
}
for(fade = 0xe1; fade <= 0xef; fade++) {
    b.i2cWriteByte(port,  fade);
    sleep.usleep(time/10);
}
