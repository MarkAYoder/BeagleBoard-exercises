#!/usr/bin/env node

var child_process = require('child_process');
var request = require('request');

var ping = "ping -c3 -i0.25 rose-hulman.edu";


child_process.exec(ping,
    function (error, stdout, stderr) {
        console.log('ping: ' + stdout);
        var test = stdout.match(/time=[0-9.]* /mg);
        for(var i =0; i<test.length; i++) {
            test[i] = test[i].substring(5);     // Strip off the leading time=
        } 
        console.log("test: " + test);
        if(error) { console.log('error: ' + error); }
        if(stderr) {console.log('stderr: ' + stderr); }
    });
