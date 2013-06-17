//******************************************************
var b = require('bonescript');
var pins = b.bone.pins;

var ledPin = pins.P9_12;
var ledPin2 = pins.USR3;

b.pinMode(ledPin, b.OUTPUT);
b.pinMode(ledPin2, b.OUTPUT);

var state = b.LOW;
b.digitalWrite(ledPin, state);
b.digitalWrite(ledPin2, state);
setInterval(toggle, 100);

function toggle() {
	if (state == b.LOW) {
		state = b.HIGH;
	}
	else {
		state = b.LOW;
	}
	b.digitalWrite(ledPin, state);
	b.digitalWrite(ledPin2, state);
}
//******************************************************