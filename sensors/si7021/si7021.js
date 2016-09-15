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

wire.readBytes(0x00, 5, onReadByte);

function onReadByte(err, res) {
	if(err) {
		console.log("onReadByte: err: " + util.inspect(err));
	}
	console.log("onReadByte: " + util.inspect(res));
	// if(x.event == 'callback') {
	// 	console.log('onReadByte: ' + JSON.stringify(x));
	// }
}


// 	// Send humidity measurement command(0xF5)
console.log("Sending read humidity command...");
wire.writeBytes(0xf5, [1], function(err) {
	if(err) {
		console.log("writeBytes: 0xf5: " + err);
	}
})

setTimeout(readHumid, wait);
// 	// Read 2 bytes of humidity data
// 	// humidity msb, humidity lsb
function readHumid2() {
	var hi, lo, humidity;
	console.log("Reading humidity");
	wire.readByte(function(err, res) {
		if(err) {
			console.log("readHumid: err: " + err);
		}
		console.log("readHumid: " + res);
		hi = res;
		wire.readByte(function(err, res) {
			if(err) {
				console.log("readHumid2: err: " + err);
			}
			console.log("readHumid2: " + res);
			lo = res;
			humidity = (((hi<<8 + lo) * 125) / 65536) - 6;
			console.log("humidity: " + humidity);
		});
	});
}

function readHumid() {
	var humidity;
	wire.read(2, function(err, res) {
		if(err) {
			console.log("readHumid: err: " + err);
		}
		console.log("readHumid: " + res);
		humidity = (((res[0]<<8 + res[1]) * 125) / 65536) - 6;
		console.log("humidity: " + humidity);
	});
}
// 	char data[2] = {0};
// 	if(read(file, data, 2) != 2)
// 	{
// 		printf("Error : Input/output Error \n");
// 	}
// 	else
// 	{
// 		// Convert the data
// 		float humidity = (((data[0] * 256 + data[1]) * 125.0) / 65536.0) - 6;

// 		// Output data to screen
// 		printf("Relative Humidity : %.2f RH \n", humidity);
// 	}

// 	// Send temperature measurement command(0xF3)
// 	config[0] = 0xF3;
// 	write(file, config, 1); 
// 	sleep(1);

// 	// Read 2 bytes of temperature data
// 	// temp msb, temp lsb
// 	if(read(file, data, 2) != 2)
// 	{
// 		printf("Error : Input/output Error \n");
// 	}
// 	else
// 	{
// 		// Convert the data
// 		float cTemp = (((data[0] * 256 + data[1]) * 175.72) / 65536.0) - 46.85;
// 		float fTemp = cTemp * 1.8 + 32;

// 		// Output data to screen
// 		printf("Temperature in Celsius : %.2f C \n", cTemp);
// 		printf("Temperature in Fahrenheit : %.2f F \n", fTemp);
// 	}
// }
