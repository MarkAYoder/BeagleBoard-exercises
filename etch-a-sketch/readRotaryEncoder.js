// This reads a rotary encoder
// The encoder has two outputs, A and B. Both are pulled normally high.
// When turned clockwise, A is pulled low first, then B.
// When turned counter clockwise, B is pulled low first.
// This is from http://yoder-black-bone.dhcp.rose-hulman.edu/attachInterrupt.html

var b = require('bonescript');

exports.readRotaryEncoder = function (pinA, pinB, CWcallback, CCWcallback) {
	var CW  = false,
		CCW = false;

	b.pinMode(pinA, b.INPUT);
	b.pinMode(pinB, b.INPUT);

	b.attachInterrupt(pinA, true, b.FALLING, interruptCallbackA1);
	b.attachInterrupt(pinB, true, b.FALLING, interruptCallbackB1);

	function interruptCallbackA1(x) {
		// console.log('A:', countA, x.value);
		if (CW) {  // You got 2 A's before a B
			return;
		}
		if (CCW) { // It was turned CCW and no A is responding
			CCW = false;
			return;
		}
		if (parseInt(x.value, 10) === 0) {
			CW = true;  // A has been pulled low before B
			CWcallback();
		}
	}

	function interruptCallbackB1(x) {
		// console.log('B:', countB, x.value);
		if (CCW) {
			return;
		}
		if (CW) {
			CW = false;
			return;
		}
		if (parseInt(x.value, 10) === 0) {
			CCW = true;
			CCWcallback();
		}
	}
};