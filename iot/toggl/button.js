#!/usr/bin/env node
// From: http://7eggs.github.io/node-toggl-api/

// Wait for a button press.  Once pressed and released, check which time entry
//  is currently running.  If it's project matches a given project, turn on 
//  the LED.

//  Mark A. Yoder 28-July-2016

if(!process.env.TOGGL_API_KEY) {
    console.log("Set TOGGL_API_KEY. Get apiToken at https://toggl.com/app/profile");
    process.exit();
}
var b = require('bonescript');
var util = require('util');
var TogglClient = require('toggl-api');
var toggl = new TogglClient({apiToken: process.env.TOGGL_API_KEY});
  
var button = 'P9_30';
var LED    = 'P9_14';

b.pinMode(button, b.INPUT);
b.pinMode(LED, b.OUTPUT);
b.attachInterrupt(button, true, b.FALLING, buttonPressed);
b.digitalWrite(LED, 1);
        
// Get current time entry when button pressed
function buttonPressed(x) {
    if(x.attached) {
        console.log("Button interupt attached");
        return;
    }
    // console.log("buttonPressed: " + util.inspect(x));
    toggl.getCurrentTimeEntry( function(err, timeEntry) {
        if(err) {
            console.log("err: " + err);
            return;
        }
        console.log("timeEntry: " + util.inspect(timeEntry))
        if(!timeEntry) {
            b.digitalWrite(LED, 0);
            return;
        }
        console.log("timeEntry.pid: " + timeEntry.pid)
        if(timeEntry.pid == '15466889') {
            b.digitalWrite(LED, 1);
        } else {
            b.digitalWrite(LED, 0);
        }
    });
}