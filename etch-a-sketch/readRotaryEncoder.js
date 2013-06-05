// This reads a rotary encoder
// The encoder has two outputs, A and B. Both are pulled normally high.
// When turned clockwise, A is pulled low first, then B.
// When turned counter clockwise, B is pulled low first.
// This is from http://yoder-black-bone.dhcp.rose-hulman.edu/attachInterrupt.html

var b = require('bonescript');

exports.readRotaryEncoder = function(pinA, pinB, CWcallback, CCWcallback) {
	var sawA = false,
		sawB = false;

	b.pinMode(pinA, b.INPUT);
	b.pinMode(pinB, b.INPUT);

	b.attachInterrupt(pinA, true, b.FALLING, interruptCallbackA1);
	b.attachInterrupt(pinB, true, b.FALLING, interruptCallbackB1);

	function interruptCallbackA1(x) {
		// console.log('A:', countA, x.value);
		if (parseInt(x.value, 10) === 0) {
			if (sawB) {
                sawB = false;
				CCWcallback();
			} else {
				sawA = true; // A has been pulled low before B
			}
		}
	}

	function interruptCallbackB1(x) {
		// console.log('B:', countB, x.value);
		if (parseInt(x.value, 10) === 0) {
			if (sawA) {
				sawA = false;
				CWcallback();
			} else {
				sawB = true;
			}
		}
	}
};