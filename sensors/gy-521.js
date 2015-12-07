#!/usr/bin/env node
// Code for reading a gy-521 gyroscope
// Inspired by http://playground.arduino.cc/Main/MPU-6050#short
// BoneScript API: https://github.com/jadonk/bonescript
// Based on code from the BeagleBone Cookbook: http://shop.oreilly.com/product/0636920033899.do
// Mark A. Yoder, 2-Sep-2015

var b = require('bonescript');
var port  = '/dev/i2c-2';		// Use bus 2
var gy521 = 0x68;
var ms    = 2000;				// Repeat time in ms

b.i2cOpen(port, gy521);

// i2cWriteBytes(port, command, bytes, [callback])
b.i2cWriteBytes(port, 0x6b, [0]); // Wake up MPU6050

setInterval(readData, ms)

function readData() {
	// i2cReadBytes(port, command, length, [callback])
	b.i2cReadBytes(port, 0x3b, 14, displayData);
}

// 16-btt values are stored as high-byte, then low-byte
// <<8 shifts lower bits to upper bit and | or's upper with lower
// <<16 >>16 shift everything up 16 bits and then back, thus sign-extending
//   the value
function displayData(x) {
	var gy;
	if(x.event === 'return') {
		gy = {
			accel: {
				x: ((x.return[0]<<8 | x.return[1])<<16)>>16,
				y: ((x.return[2]<<8 | x.return[3])<<16)>>16,
				z: ((x.return[4]<<8 | x.return[5])<<16)>>16
			},
			temp:  (((x.return[6]<<8 | x.return[7])<<16)>>16)/340+36.53,
			gyro: {
				x: ((x.return[ 8]<<8 | x.return[ 9])<<16)>>16,
				y: ((x.return[10]<<8 | x.return[11])<<16)>>16,
				z: ((x.return[12]<<8 | x.return[13])<<16)>>16 
			}
		};
		console.log(gy);
	}
}