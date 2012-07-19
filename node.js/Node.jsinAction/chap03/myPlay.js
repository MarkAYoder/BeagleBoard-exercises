// I'm see if I can use node.js for simple tasks.
"use strict";

var fs = require('fs'),
    list,
    util = require('util'),
    os = require('os');

/*
console.log('fs:');
for (list in fs) {
    console.log(list);
}

console.log('console:');
for (list in console) {
    console.log(list);
}
*/


//console.log(util.inspect(util, true, null, true));

//console.log(util.inspect(fs, true, null, true));

util.log('This is a test.');

/*
setInterval(function () {
    util.log("I'm testing...");
}, 500);
*/

// console.dir(fs);

/*
// Start reading from stdin so we don't exit.
process.stdin.resume();

process.on('SIGINT', function () {
    console.log('Got SIGINT.  Press Control-D to exit.');
});
*/

//console.log(util.inspect(os, true, null, true));

/*
for (list in os) {
    console.log(list + ': ' + os.list());
}
*/
