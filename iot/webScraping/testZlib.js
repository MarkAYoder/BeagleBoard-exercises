#!/usr/bin/env node
// 
const zlib = require('zlib');

const input = '.................................';
zlib.gzip(input, function(err, buffer) {
  if (!err) {
    console.log(buffer.toString('base64'));
  } else {
    console.log("err: " + err);
  }
});

const buffer = new Buffer('H4sIAAAAAAAAA9PTIwAAv0QEASEAAAA=', 'base64');
zlib.gunzip(buffer, function(err, buffer) {
  if (!err) {
    console.log(buffer.toString());
  } else {
    console.log("err: " + err);
  }
});