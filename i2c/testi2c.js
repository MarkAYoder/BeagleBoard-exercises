#!/usr/bin/env node
// npm install -g i2c
// From: https://www.npmjs.org/package/i2c
// wire.scan doesn't seem to work, but the rest does.
var i2c = require('i2c');
var address = 0x40;

var wire = new i2c(address, {device: '/dev/i2c-1', debug: false}); // point to your i2c address, debug provides REPL interface

// wire.scan(function(err, data) {
//   // result contains an array of addresses
//   console.log("err: " + err);
//   console.log("data: " + JSON.stringify(data));
// });

// var byte = 0;
// wire.writeByte(byte, function(err) {
//   console.log("writeByte err: " + err);
// });

// wire.writeBytes(command, [byte0, byte1], function(err) {});

// wire.readByte(function(err, res) { // result is single byte 
//   console.log("err: " + err);
//   console.log("res: " + res);
// })

var command = 0;
var length = 2;
wire.readBytes(command, length, function(err, res) {
  // result contains a buffer of bytes
  console.log("err: " + err);
  console.log("res: " + JSON.stringify(res));
  var hi = res.readInt8(0);
  var lo = res.readUInt8(1);
  console.log((hi << 8) | lo);
});

wire.on('data', function(data) {
  // result for continuous stream contains data buffer, address, length, timestamp
  console.log("wire.on: " + JSON.stringify(data));
});

var delay = 500;
wire.stream(command, length, delay); // continuous stream, delay in ms
