#!/usr/bin/env node
// Pings google until it gets a response and then beeps.

var child_process = require('child_process');
var ms = 1000;  // Repeat time.

var pingCmd = "ping -c1 -i1 google.com";
console.log("process.argv.length: " + process.argv.length);
if(process.argv.length === 3) {
    pingCmd = process.argv[2];
}

var timer = setInterval(ping, ms);

// Send off the ping command.
function ping  () {
    child_process.exec(pingCmd,
        function (error, stdout, stderr) {
            console.log('ping: ' + stdout);
            if(error || stderr) { 
                console.log('error: ' + error); 
                console.log('stderr: ' + stderr); 
            } else {
                console.log("ping returned");
                clearInterval(timer);
            }
        }
    )
}