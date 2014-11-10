#!/usr/bin/env node
// npm install -g i2c

var b = require('bonescript');
var sleep = require('sleep');
var port = '/dev/i2c-2'
var TMP102 = 0x70;
var time = 1000; // Delay between images.

// The first btye is GREEN, the second is RED.
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
        b.i2cWriteByte(port,  0x21); // Start oscillator (p10)
    	b.i2cWriteByte(port,  0x81); // Disp on, blink off (p11)
    	b.i2cWriteByte(port,  0xe7); // Full brightness (page 15)

        b.i2cWriteBytes(port, 0x00, frown);
        setTimeout(function() {
            b.i2cWriteBytes(port, 0x00, neutral);
        }, time);
        setTimeout(function() {
            b.i2cWriteBytes(port, 0x00, smile);
        }, 2*time);
        // Fade the display
    // 	int daddress;
    // 	for(daddress = 0xef; daddress >= 0xe0; daddress--) {
    // //	    printf("writing: 0x%02x\n", daddress);
    // 	    res = i2c_smbus_write_byte(file, daddress);
    // 	    usleep(100000);	// Sleep 0.1 seconds
    // 	}

    }
}

function onReadByte(x) {
    if (x.event == 'callback') {
        console.log('onReadByte: ' + JSON.stringify(x));
    }
}
