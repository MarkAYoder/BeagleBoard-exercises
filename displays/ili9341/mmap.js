#!/usr/bin/env node
// mmap test
var assert = require('assert');
var fs = require('fs');
var os = require('os');
var mmap = require('mmap.js');

var fd = fs.openSync("/dev/fb0", 'r+');
var buf = mmap.alloc(
    mmap.PAGE_SIZE,
    mmap.PROT_READ | mmap.PROT_WRITE,
    mmap.MAP_PRIVATE,
    fd,
    0);
fs.closeSync(fd);
assert(buf);
