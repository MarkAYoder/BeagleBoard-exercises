#!/usr/bin/node
// Program to test looking up information in /usr/share/bone101/static/bone.js

var b = require('bonescript');

/*
process.argv.forEach(function(val, index, array) {
	console.log(index + ': ' + val);
});
*/

var gpio = process.argv[2].toUpperCase();
if (gpio[0] === 'P') {
	console.log(b.bone.pins[gpio]);
} else {
	console.log("Looking for gpio " + gpio);
	for (var i in b.bone.pins) {
		if (b.bone.pins[i].gpio === parseInt(gpio,10)) {
			console.log(b.bone.pins[i]);
		}
	}
}
