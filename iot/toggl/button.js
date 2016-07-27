#!/usr/bin/env node
// From: http://7eggs.github.io/node-toggl-api/

var b = require('bonescript');
var util = require('util');
var TogglClient = require('toggl-api')
// Get apiToken at https://toggl.com/app/profile
  , toggl = new TogglClient({apiToken: 'bbf1e58094b22ca5c098ffdaf72b2beb'})
  
var button = 'P9_30';
var LED = 'P9_14';

b.pinMode(button, b.INPUT);
b.pinMode(LED, b.OUTPUT);
b.attachInterrupt(button, true, b.FALLING, buttonPressed);
b.digitalWrite(LED, 1);

// toggl.startTimeEntry({
//   description: 'Some cool work',
//   billable:    true
// }, function(err, timeEntry) {
//   // handle error

//   // working now exactly 1hr
//   setTimeout(function() {
//     // toggl.stopTimeEntry(timeEntry.id, function(err) {
//     //   // handle error

//     //   toggl.updateTimeEntry(timeEntry.id, {tags: ['finished']}, function(err) {
//     //     toggl.destroy()
//     //   })
//     // })
//   }, 1000)
// })

        
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