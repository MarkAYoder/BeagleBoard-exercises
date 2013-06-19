// This is one of Keith's ece530 projects
// Two IR detectors are mounted on a servo motor.
// The motor is controlled via pins P9 11, 13, 15 and 17

var b = require('bonescript');

var controller = ["P9_11", "P9_13", "P9_15", "P9_17"];
var i;

for(i=0; i<controller.length; i++) {
    b.pinMode(controller[i], b.OUTPUT);
}

b.pinMode(ledPin, b.OUTPUT);
b.pinMode(ledPin2, b.OUTPUT);

var state = [b.LOW, bHIGH, b.HIGH, b.LOW];
for(i=0; i<controller.length; i++) {
    b.digitalWrite(controller[i], state[i]);
}

b.digitalWrite(ledPin, state);
b.digitalWrite(ledPin2, state);

setInterval(toggle, 100);

function toggle() {
    if (state == b.LOW) state = b.HIGH;
	else state = b.LOW;
	b.digitalWrite(ledPin, state);
	b.digitalWrite(ledPin2, state);
    for (i = 0; i < controller.length; i++) {
    	b.digitalWrite(controller[i], state);
    }
}
