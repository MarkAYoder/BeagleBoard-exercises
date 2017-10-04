#!/usr/bin/env node
// mmap test
var assert = require('assert');
var fs = require('fs');
var os = require('os');
var mmap = require('mmap.js');

const XMAX = 320;
const YMAX = 240;

var fd = fs.openSync("/dev/fb0", 'r+');
var buf = mmap.alloc(
    2*XMAX*YMAX,
    mmap.PROT_READ | mmap.PROT_WRITE,
    mmap.MAP_PRIVATE,
    fd,
    0);

fs.closeSync(fd);
assert(buf);

// console.log("buf: " + buf);
for(var i=0; i<XMAX; i++) {
    buf.write("X", i);
}
mmap.sync(buf, 0, mmap.PAGE_SIZE, mmap.MS_SYNC);

buf = null;

// console.log("buf: " + buf);
