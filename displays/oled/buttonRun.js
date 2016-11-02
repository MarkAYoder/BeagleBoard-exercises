#!/usr/bin/env node
// Runs a given command when a button is pressed

console.log("Loading bonescript...");
var b             = require('bonescript');
console.log("Loading child_process...");
var exec = require('child_process').exec;

var inputPin = 'P8_45';
var runMe = "./weatherStation.js";
if(process.argv.length >= 3) {
    runMe = process.argv[2];
}
if(process.argv.length === 4) {
    inputPin = process.argv[3];
}

b.pinMode(inputPin, b.INPUT);

b.attachInterrupt(inputPin, true, b.FALLING, interruptCallback);

function interruptCallback(x) {
    if(!x.attached) {
        console.log("Callback");
        exec(runMe, function(err, stdout, stderr) {
            if(err) {
                console.log("err: " + err);
            }
            if(stderr) {
                console.log("stderr: " + stderr);
            }
            if(stdout) {
                console.log("stdout: " + stdout);
            }
         });
    }
}

console.log("Ready to run %s on %s...", runMe, inputPin);
