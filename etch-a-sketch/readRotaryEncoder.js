// This reads a rotary encoder
// The encoder has two outputs, A and B. Both are pulled normally high.
// When turned clockwise, A is pulled low first, then B.
// When turned counter clockwise, B is pulled low first.

// This is from http://yoder-black-bone.dhcp.rose-hulman.edu/attachInterrupt.html

var b = require('bonescript');
var countA = 0,
    countB = 0,
    rotate = 0,
    CW  = true,
    CCW = true;
var inputPinA1 = 'P9_30',
    inputPinB1 = 'P9_27';
b.pinMode(inputPinA1, b.INPUT);
b.pinMode(inputPinB1, b.INPUT);

b.attachInterrupt(inputPinA1, true, b.FALLING, interruptCallbackA1);
b.attachInterrupt(inputPinB1, true, b.FALLING, interruptCallbackB1);
setTimeout(detach, 20000);

function interruptCallbackA1(x) {
 countA++;
// console.log('A:', countA, x.value);
 if(CCW) {
     CCW = false;
     return;
 }
 if(parseInt(x.value,10) === 0) {
     rotate++;
     CW = true;
     console.log('rotate: ', rotate);
 }
}

function interruptCallbackB1(x) {
 countB++;
// console.log('B:', countB, x.value);
 if(CW) {
     CW = false;
     return;
 }
 if(parseInt(x.value,10) === 0) {
     rotate--;
     CCW = true;
     console.log('rotate: ', rotate);
 }
}

function detach() {
 b.detachInterrupt(inputPinA1);
 b.detachInterrupt(inputPinB1);
 console.log("All Done!");
}