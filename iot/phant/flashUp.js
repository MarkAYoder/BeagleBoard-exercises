#!/usr/bin/env node
// Pings google until it gets a response and then beeps.
// apt-get install flite

var child = require('child_process');
var b = require('bonescript');

var pingCmd = "ping -w1 google.com";
var ms = 15000;          // Repeat time in ms.
var thresh = 65.0;      // If time is above this, turn on warning light
var hist = new Array(10);
var current = 0;        // Insert next value here 
var red   = 'P9_11';
var green = 'P9_15';
var blue  = 'P9_13';

for(var i = 0; i<hist.length; i++) {    // Initialize history to threshold
    hist[i] = thresh;
}

b.pinMode(red,   b.OUTPUT);
b.pinMode(green, b.OUTPUT);
b.pinMode(blue,  b.OUTPUT);

b.digitalWrite(red,   0);
b.digitalWrite(green, 0);
b.digitalWrite(blue,  0);

// console.log("process.argv.length: " + process.argv.length);
if(process.argv.length === 3) {
    pingCmd = process.argv[2];
}

var timer = setInterval(ping, ms);

// Send off the ping command.
function ping  () {
    child.exec(pingCmd,
        function (error, stdout, stderr) {
            if(error || stderr) { 
                console.log('error: ' + error); 
                console.log('stderr: ' + stderr); 
                b.digitalWrite(red,   1);
                b.digitalWrite(green, 0);
                b.digitalWrite(blue,  0);
            } else {
                var time = stdout.match(/time=[0-9.]* /mg); //  Pull the time out of the return string
                time[0] = parseFloat(time[0].substring(5));     // Strip off the leading time=
                var average = 0;
                for(var i=0; i<hist.length; i++) {
                    average += hist[i];
                }
                average /= hist.length;
                hist[current] = time[0];
                current++;
                if(current >= hist.length) {    // Keep a circular buffer of
                    current=0;                  // most recent values
                }

                console.log('ping: time = %d, average = %d', time[0].toFixed(2), average.toFixed(2));
                if(time[0] > 1.1*average) {  // Turn on warning
                    b.digitalWrite(red,   1);
                    b.digitalWrite(green, 1);
                    b.digitalWrite(blue,  0);
                } else {
                    b.digitalWrite(red,   0);
                    b.digitalWrite(green, 1);
                    b.digitalWrite(blue,  0);
                }
            }
        }
    )
}

process.on('SIGINT', function() {
    console.log('Got SIGINT');
    clearInterval(timer);
    setTimeout(allOff, 1000);
});

function allOff() {
    console.log("allOff");
    b.digitalWrite(red,   0);
    b.digitalWrite(green, 0);
    b.digitalWrite(blue,  0);
}
