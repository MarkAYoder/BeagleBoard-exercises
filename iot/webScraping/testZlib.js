#!/usr/bin/env node
// 
const zlib = require('zlib');

const input = '.................................';
zlib.deflate(input, function(err, buffer) {
  if (!err) {
    console.log(buffer.toString('base64'));
  } else {
    console.log("err: " + err);
  }
});

const buffer = new Buffer('eJzT0yMAAGTvBe8=', 'base64');
zlib.unzip(buffer, function(err, buffer) {
  if (!err) {
    console.log(buffer.toString());
  } else {
    console.log("err: " + err);
  }
});