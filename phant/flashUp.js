#!/usr/bin/env node
// Pings google until it gets a response and then beeps.
// apt-get install flite

var child = require('child_process');
var b = require('bonescript');

var ms = 1500;  // Repeat time.
var red   = 'P9_11';
var green = 'P9_13';
var blue  = 'P9_15';

b.pinMode(red,   b.OUTPUT);
b.pinMode(green, b.OUTPUT);
b.pinMode(blue,  b.OUTPUT);

b.digitalWrite(red,   1);
b.digitalWrite(greeb, 0);
b.digitalWrite(blue,  0);


var pingCmd = "ping -w1 google.com";
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
            } else {
                console.log('ping: ' + stdout);
            }
        }
    )
}
