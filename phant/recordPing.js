#!/usr/bin/env node
// Measure the time to send a ping and log it on phant
// Go to http://14.139.34.32:8080/streams/make and create a new stream
// Save the keys json file and copy to keys.json
// Run this script

var child_process = require('child_process');
var request       = require('request');
var util          = require('util');
var fs            = require('fs');

var ping = "ping -c1 -i1 rose-hulman.edu";
var filename = "/root/exercises/phant/keys.json";
console.log("process.argv.length: " + process.argv.length);
if(process.argv.length === 3) {
    filename = process.argv[2];
}
console.log("Using: " + filename);
var keys = JSON.parse(fs.readFileSync(filename));
// console.log(util.inspect(keys));

var url = keys.inputUrl + "/?private_key=" + keys.privateKey + "&time=";

// Send off the ping command.
child_process.exec(ping,
    function (error, stdout, stderr) {
        // console.log('ping: ' + stdout);
        var time = [0];             // Report time=0 if an error.
        if(error || stderr) { 
            console.log('error: ' + error); 
            console.log('stderr: ' + stderr); 
        } else {    
            time = stdout.match(/time=[0-9.]* /mg); //  Pull the time out of the return string
            for(var i =0; i<time.length; i++) {
                time[i] = time[i].substring(5);     // Strip off the leading time=
            } 
        }
        
        // console.log("time: " + time);
        console.log("url: " + url+time[0]);
        
        // Send the time to the phant server.
        request(url+time[0], function (error, response, body) {
          if (!error && response.statusCode == 200) {
            console.log(body); 
          } else {
            console.log("error=" + error + " response=" + JSON.stringify(response));
          }
        });

    }
);
