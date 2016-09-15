#!/usr/bin/env node

// For reading si7021 humidity/temperature module
// Mark A. Yoder
// 2-Aug-2016

var i2c = require('i2c');
var util = require('util');

var bus = '/dev/i2c-2';
var sensor = 0x40;

var wait = 1000;  // time in ms to wait from giving command to reading data.

var wire = new i2c(sensor, {device: bus});

// Send humidity measurement command(0xF5)
console.log("Sending read humidity command...");
wire.writeBytes(0xf5, [1], function(err) {
	if(err) {
		console.log("writeBytes: 0xf5: " + err);
	}
	setTimeout(readHumid, wait);
});

// Read 2 bytes of humidity data
// humidity msb, humidity lsb
function readHumid() {
	var humidity;
	wire.read(2, function(err, res) {
		if(err) {
			console.log("readHumid: err: " + err);
		}
		// console.log("readHumid: " + res);
		humidity = ((((res[0]<<8) + res[1]) * 125) / 65536) - 6;
		console.log("humidity: " + humidity);
		sendTempCmd();
	});
}

// Send temperature measurement command(0xF3)
function sendTempCmd() {
	console.log("Sending read temperature command...");
	wire.writeBytes(0xf3, [1], function(err) {
		if(err) {
			console.log("writeBytes: 0xf3: " + err);
		}
		setTimeout(readTemp, wait);
	});
}
// Read 2 bytes of temperature data
// temperature msb, temperature lsb
function readTemp() {
	var temperature;
	wire.read(2, function(err, res) {
		if(err) {
			console.log("readTemp: err: " + err);
		}
		// console.log("readTemp: " + res);
		temperature = ((((res[0]<<8) + res[1]) * 175.72) / 65536) - 46.85;
		console.log("temperature: " + temperature);
	});
}
