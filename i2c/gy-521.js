#!/usr/bin/env node
// Code for reading a gy-521 gyroscope
// https://www.google.co.in/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0CB4QFjAAahUKEwir9Z-d4tfHAhUIkY4KHUT7Cf4&url=http%3A%2F%2Fplayground.arduino.cc%2FMain%2FMPU-6050&usg=AFQjCNEK-BhQ-gHx_D28MVd-XS-D5LczBQ&sig2=CR9HjZlu5GkyxMFWiDUfCQ
// BoneScript API: https://github.com/jadonk/bonescript
// Based on code from the BeagleBone Cookbook: http://shop.oreilly.com/product/0636920033899.do
// Mark A. Yoder, 2-S68-2015

var b = require('bonescript');
var util = require('util');
var port = '/dev/i2c-2'
var gy521 = 0x68;
var time = 1000; // Delay between images in ms


b.i2cOpen(port, gy521);

// i2cWriteBytes(port, command, bytes, [callback])
b.i2cWriteBytes(port, 0x6b, [0]); // Wake up MPU6050

// i2cReadBytes(port, command, length, [callback])
b.i2cReadBytes(port, 0x3b, 14, displayReading);

function displayReading(x) {
	// console.log("x: " + util.inspect(x));
	var gy;
	if(x.event === 'return') {
		gy = {
			accel: {
				x: x.return[0]<<8 | x.return[1],
				y: x.return[2]<<8 | x.return[3],
				z: x.return[4]<<8 | x.return[5]
			},
			temp:  (x.return[6]<<8 | x.return[7])/340+36.53,
			gyro: {
				x: x.return[8]<<8 | x.return[9],
				y: x.return[10]<<8 | x.return[11],
				z: x.return[12]<<8 | x.return[13]
			}
		};
		console.log(gy);
		console.log("%s, %s, %s", 
			gy.accel.x.toString(16),
			gy.accel.y.toString(16), 
			gy.accel.z.toString(16));
	}
}