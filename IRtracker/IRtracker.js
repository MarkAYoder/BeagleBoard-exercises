// This is one of Keith's ece530 projects
// Two IR detectors are mounted on a servo motor.
// The motor is controlled via pins P9 11, 13, 15 and 17

var b = require('bonescript');

var controller = ["P9_11", "P9_13", "P9_15", "P9_16"];  // Motor is attached here
var PT         = [{pin: "P9_37", value: 0}, {pin: "P9_35", value: 0}];  // Phototransistor inputs
var buttons    = ["P9_41", "P9_42"];         // Pushbuttons
var mState = [b.LOW, b.HIGH, b.HIGH, b.LOW]; // Pulse sequence for motor
var off   = [b.LOW, b.LOW,  b.LOW,  b.LOW]; // Turn motor off
var steps = 20;                             // 20 steps is one turn
var rotateDelay = 200;   // ms delay when turning motor
var CW  = 0;
var CCW = 1;

var state = {search: steps, rotate: 0, track: 0};   // Initialy search 360 degrees
var searchTime = 100;       // Time between search steps
var searchMin = 2;           // Smallest value seen in search.  Start with 2mv
var searchIdx;               // Index of smallest value
var trackTime = 100;
var trackThresh = 0.9;    // If above this the IR sourse has been lost
var turnThresh = 0.25;    // Difference needed to turn
var rotateTime = 50;

var i;

// Initialize motor control pins to be OUTPUTs
for(i=0; i<controller.length; i++) {
    b.pinMode(controller[i], b.OUTPUT);
}
// Initialize buttons as INPUTs.
for(i=0; i<buttons.length; i++) {
    b.pinMode(buttons[i], b.INPUT);
}
// Put the motor into a known state
updateState(mState);
readPT();
rotate(CW);
setTimeout(search, searchTime);

// Look for the brightest reading while turning.
// call searcthTime ms after starting readPT() and rotateCW()
function search() {
    // At this point the sensors have turned and the PT have been read
    console.log("search: " + state.search);
    for(var i=0; i<PT.length; i++) {
        if(PT[i].value < searchMin) {
            searchMin = PT[i].value;
            searchIdx = state.search;
            console.log("New min: " + searchMin + ", at: " + searchIdx);
        }
    }
    state.search--;
    if (state.search === 0) { // Done searching, move to brightest spot
        console.log("Done searching");
        state.rotate = searchIdx; // Number of steps to rotate
        rotate(CCW);
        setTimeout(rotateMe, rotateTime);
    } else {
        readPT();
        rotate(CW);
        setTimeout(search, searchTime);
    }
}


// Called to rotate several steps
// call rotateCCW() or rotateCW() before calling
function rotateMe() {
    console.log("rotateMe: " + state.rotate);
    state.rotate--;
    if(state.rotate === 0) {
        // We're ready to track
        console.log("Start tracking");
        readPT();
        state.track = 10;
        setTimeout(track, trackTime);
    } else {
        rotate(CCW);
        setTimeout(rotateMe, rotateTime);
    }
}

// Looks for brightest PT
function track() {
    console.log("track: " + state.track);
    state.track--;
    // Have you lost the IR source?
    if(PT[0].value > trackThresh && PT[i].value > trackThresh && state.track<0) {
        // start searching again
        readPT();
        rotate(CW);
        state.search = steps;
        setTimeout(search, searchTime);
    } else if((PT[0].value-PT[1].value) > turnThresh) {
        readPT();
        rotate(CCW);
        setTimeout(track, trackTime);
    } else if((PT[1].value-PT[0].value) > turnThresh) {
        readPT();
        rotate(CW);
        setTimeout(track, trackTime);
    } else {
        readPT();
        setTimeout(track, trackTime);
//        updateState(off);
    }
}

// One button goes CW the other CCW
//readButtons();
//b.attachInterrupt(buttons[0], true, b.RISING, rotateCW);
//b.attachInterrupt(buttons[1], true, b.RISING, rotateCCW);


//setInterval(readPT, 500);

// Write the current input state to the controller
function updateState(mState) {
	for (i = 0; i < controller.length; i++) {
		b.digitalWrite(controller[i], mState[i]);
	}
}

// This the the general rotate funtion
function rotate(direction) {
//	console.log("rotate(%d,%d)", direction, count);
    // Rotate the state acording to the direction of rotation
	if (direction === CW) {
		mState = [mState[1], mState[2], mState[3], mState[0]];
	}
	else {
		mState = [mState[3], mState[0], mState[1], mState[2]];
	}
	updateState(mState);
}

function readButtons() {
    console.log("readButtons");
    b.digitalRead(buttons[0], function(x) {printStatus(buttons[0], x);});
    b.digitalRead(buttons[1], function(x) {printStatus(buttons[1], x);});
}


// Read the Photo Transistors and store their values
function readPT() {
var i;
	for (i = 0; i < PT.length; i++) {
        try {
            PT[i].value = b.analogRead(PT[i].pin);
//    		console.log("%s: %d", PT[i].pin, PT[i].value);
        } catch(err) {
            
        }
	}
}

function printStatus(pin, x) {
    console.log(pin + ': x.value = ' + x.value + ', x.err = ' + x.err);
}
