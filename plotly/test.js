#!/usr/bin/env node
var plotly = require('plotly')("MarkYoder", "vpdtuxmriz");

var data = [{x:[0,1,2], y:[3,2,1], type: 'bar'}];
var layout = {fileopt : "extend", filename : "Mark A. Yoder Test"};

plotly.plot(data, layout, function (err, msg) {
    if (err) return console.log(err);
    console.log(msg);
});
