// This is one of Keith's ece530 projects
// Two IR detectors are mounted on a servo motor.
// The motor is controlled via pins P9 11, 13, 15 and 17

var b = require('bonescript');

var controller = ["P9_11", "P9_13", "P9_15", "P9_16"];
var i;

for(i=0; i<controller.length; i++) {
    b.pinMode(controller[i], b.OUTPUT);
}

var state = [b.LOW, b.HIGH, b.HIGH, b.LOW];
for(i=0; i<controller.length; i++) {
    b.digitalWrite(controller[i], state[i]);
}

setInterval(CWrotate, 50);

function CWrotate() {
	state = [state[1], state[2], state[3], state[0]];
	for (i = 0; i < controller.length; i++) {
		b.digitalWrite(controller[i], state[i]);
	}
}

function CCWrotate() {
    state = [state[3], state[0], state[1], state[2]];
	for (i = 0; i < controller.length; i++) {
		b.digitalWrite(controller[i], state[i]);
	}
}