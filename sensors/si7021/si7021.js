#!/usr/bin/env node 

// For reading si7021 humidity/temperature module
// Datasheet: https://www.silabs.com/Support%20Documents%2FTechnicalDocs%2FSi7021-A20.pdf
// Mark A. Yoder
// 15-Sept-2016

var i2c = require('i2c');

var bus = '/dev/i2c-2';	// Which i2c bus
var addr = 0x40;		// Address on bus

var wait = 10;  // time in ms to wait from giving command to reading data.

var sensor = new i2c(addr, {device: bus});

// Send humidity measurement command(0xF5)
// console.log("Sending read humidity command...");
sensor.writeBytes(0xf5, [1], function(err) {
	if(err) {
		console.log("writeBytes: 0xf5: " + err);
	}
	setTimeout(readHumid, wait);	// Give device time to make measurment
});

// Read 2 bytes of humidity data
// humidity msb, humidity lsb
function readHumid() {
	var humidity;
	sensor.read(2, function(err, res) {
		if(err) {
			console.log("readHumid: err: " + err);
		}
		// console.log("readHumid: " + res);
		humidity = ((((res[0]<<8) + res[1]) * 125) / 65536) - 6;	// p21
		console.log("humidity: " + humidity.toFixed(2));
		sendTempCmd();
	});
}

// Send temperature measurement command(0xF3)
// The exe0 command says to return the temp measured when the humidity was read. p21
function sendTempCmd() {
	// console.log("Sending read temperature command...");
	sensor.writeBytes(0xe0, [1], function(err) {
		if(err) {
			console.log("writeBytes: 0xe0: " + err);
		}
		readTemp();	// No need to wait since it was computed with humidity
	});
}

// Read 2 bytes of temperature data
// temperature msb, temperature lsb
function readTemp() {
	var temperature;
	sensor.read(2, function(err, res) {
		if(err) {
			console.log("readTemp: err: " + err);
		}
		// console.log("readTemp: " + res);
		temperature = ((((res[0]<<8) + res[1]) * 175.72) / 65536) - 46.85;
		console.log("temperature: " + temperature.toFixed(2));
	});
}
