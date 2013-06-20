// This is one of Keith's ece530 projects
// Two IR detectors are mounted on a servo motor.
// The motor is controlled via pins P9 11, 13, 15 and 17

var b = require('bonescript');

var controller = ["P9_11", "P9_13", "P9_15", "P9_16"];  // Motor is attachedhere
var PT         = ["P9_33", "P9_35"];                    // Phototransistor inputs
var buttons    = ["P9_41", "P9_42"];                    // Pushbuttons
var state = [b.LOW, b.HIGH, b.HIGH, b.LOW]; // Pulse sequence for motor
var steps = 20;                             // 20 steps is one turn
var rotateDelay = 50;   // ms delay when turning motor
var CW  = 0;
var CCW = 1;

var i;

// Initialize motor control pins to be OUTPUTs
for(i=0; i<controller.length; i++) {
    b.pinMode(controller[i], b.OUTPUT);
}
// Initialize buttons as INPUTs.
for(i=0; i<buttons.length; i++) {
    b.pinMode(buttons[i], b.INPUT);
}
// Put the motor into a know state
updateState(controller, state, steps, rotateDelay);

// One button goes CW the other CCW
readButtons();
b.attachInterrupt(buttons[0], true, b.RISING, rotateCW);
b.attachInterrupt(buttons[1], true, b.RISING, rotateCCW);

//readPT();
//setInterval(readPT, 500);

// Write the current input state to the controller
function updateState() {
	for (i = 0; i < controller.length; i++) {
		b.digitalWrite(controller[i], state[i]);
	}
}

// These rotate just one step CW or CCW
function rotateCW() {
    rotate(CW, 1);
}
function rotateCCW() {
    rotate(CCW, 1);
}
// This the the general rotate funtion
function rotate(direction, count) {
	console.log("rotate(%d,%d)", direction, count);
	count--;
    // Rotate the state acording to the direction of rotation
	if (direction === 0) {
		state = [state[1], state[2], state[3], state[0]];
	}
	else {
		state = [state[3], state[0], state[1], state[2]];
	}
	updateState();
    // Schedule next rotation
	if (count > 0) {
		setTimeout(function() {
			rotate(direction, count);
		}, rotateDelay);
	}
}

function readButtons() {
    console.log("readButtons");
    b.digitalRead(buttons[0], function(x) {printStatus(buttons[0], x);});
    b.digitalRead(buttons[1], function(x) {printStatus(buttons[1], x);});
}
function readPT() {
/*
var i;
	for (i = 0; i < PT.length; i++) {
		console.log("%s: %d", PT[i], b.analogRead(PT[i]));
	}
    */
//    console.log("diff: %" + (b.analogRead(PT[0]) - b.analogRead(PT[1])));
//    console.log("%s: %d, %s: %d",   PT[0], b.analogRead(PT[0]), 
//                                    PT[1], b.analogRead(PT[1]));
    b.analogRead(PT[0], function(x) {printStatus(PT[0], x);});
    b.analogRead(PT[1], function(x) {printStatus(PT[1], x);});
}

function printStatus(pin, x) {
    console.log(pin + ': x.value = ' + x.value + ', x.err = ' + x.err);
}
