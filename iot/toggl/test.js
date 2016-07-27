#!/usr/bin/env node
// From: http://7eggs.github.io/node-toggl-api/

var util = require('util');
var TogglClient = require('toggl-api')
// Get apiToken at https://toggl.com/app/profile
  , toggl = new TogglClient({apiToken: 'bbf1e58094b22ca5c098ffdaf72b2beb'})

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

toggl.getCurrentTimeEntry( function(err, timeEntry) {
    if(err) {
        console.log("err: " + err);
    } else {
        console.log("timeEntry: " + util.inspect(timeEntry))

        toggl.getProjectData(timeEntry.pid, function(err, projectData) {
            if(err) {
                console.log("err: " + err);
            } else {
                console.log("projectData: " + util.inspect(projectData))
            }
        });
    }
});

        