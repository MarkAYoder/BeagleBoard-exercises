// Node.js in Action p57
// Working now.  You can't just 'touch' a file, you have to create a new one.
"use strict";
var events = require('events');

function Watcher(watchDir, processedDir) {
    this.watchDir = watchDir;
    this.processedDir = processedDir;
}

Watcher.prototype = new events.EventEmitter();

var fs = require('fs'),
    watchDir = './watch',
    processedDir = './done';

Watcher.prototype.watch = function () {	// Extend  EventEmitter with method that processes files
    var watcher = this,
        index;
    fs.readdir(this.watchDir, function (err, files) {
        if (err) {throw err; }
        for (index in files) {
            console.log("index: " + index);
            watcher.emit('process', files[index]);
        }
    })
}

Watcher.prototype.start = function () { 
    var watcher = this;
    console.log("start, watchDir: " + watchDir);
    fs.watchFile(watchDir, function () {
        watcher.watch();
    });
}

var watcher = new Watcher(watchDir, processedDir);
watcher.on('process', function process(file) {
    var watchFile = this.watchDir + '/' + file;
    var processedFile = this.processedDir + '/' + file.toLowerCase();
    console.log("watchFile: " + watchFile);
    console.log("processedFile: " + processedFile);

    fs.rename(watchFile, processedFile, function(err) {
        if (err) {throw err; }
    });
});

watcher.start();

