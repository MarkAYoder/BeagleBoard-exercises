#!/usr/bin/env node
// Pings google until it gets a response and then beeps.
// apt-get install flite

var child = require('child_process');
var ms = 1500;  // Repeat time.

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
                clearInterval(timer);
                console.log('ping: ' + stdout);
                speakForSelf("Bark, bark!");
            }
        }
    )
}

function speakForSelf(phrase) {
//	exec(__dirname + '/speak.sh ' + phrase, function (error, stdout, stderr) {
	child.exec('flite -t "' + phrase + '"', function (error, stdout, stderr) {
        console.log(stdout);
        if(error) { console.log('error: ' + error); }
        if(stderr) {console.log('stderr: ' + stderr); }
    });
}

