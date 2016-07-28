#!/usr/bin/env node
// From: http://7eggs.github.io/node-toggl-api/
if(!process.env.TOGGL_API_KEY) {
    console.log("Set TOGGL_API_KEY. Get apiToken at https://toggl.com/app/profile");
    process.exit();
}
var util = require('util');
var TogglClient = require('toggl-api')
var toggl = new TogglClient({apiToken: process.env.TOGGL_API_KEY});

toggl.startTimeEntry({
  description: 'Some cool work',
  billable:    true
}, function(err, timeEntry) {
  // handle error

  // working now exactly 10 seconds
//   setTimeout(function() {
//     toggl.stopTimeEntry(timeEntry.id, function(err) {
//       // handle error

//       toggl.updateTimeEntry(timeEntry.id, {tags: ['finished']}, function(err) {
//         toggl.destroy()
//       })
//     })
//   }, 10000)
})

toggl.getCurrentTimeEntry( function(err, timeEntry) {
    if(err) {
        console.log("err: " + err);
    } else {
        console.log("timeEntry: " + util.inspect(timeEntry))
        if(timeEntry) {
            toggl.getProjectData(timeEntry.pid, function(err, projectData) {
                if(err) {
                    console.log("err: " + err);
                } else {
                    console.log("projectData: " + util.inspect(projectData))
                }
            });
        }
    }
});

        