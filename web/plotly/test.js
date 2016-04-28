#!/usr/bin/env node
// Tests how to pull data from an object.

var _ = require('./underscore-min.js');
var results = [
    {"humidity":"0","pressure":"985.7","temp":"22.1","timestamp":"2016-04-28T18:41:05.778Z"},
    {"humidity":"0","pressure":"985.9","temp":"22.2","timestamp":"2016-04-28T18:26:01.779Z"},
    {"humidity":"0","pressure":"985.9","temp":"22.1","timestamp":"2016-04-28T18:11:01.665Z"}];

console.log(Object.keys(results[0]));

var timestamp = _.map(results, function(item) {
            return item.timestamp.replace('T', ' ').replace('Z', ''); // Convert to Plotly time format
        });

var data = [];
console.log("TimeStamps: %s", tmp);

var i = 0;
for(var key in results[0]) {
    if(key !== 'timestamp') {
        // console.log("Key: %s, Value: %s", key, results[0][key]);
        data[i] = {};
        data[i].x = timestamp;
        data[i].y = _.map(results, function(item) {  // Copy temp data
                return item[key];	// 
                });
    }
    i++;
}

console.log(data);