#!/usr/bin/env node
// Doesn't work.  gets: arg: { err: [Error: Cannot write to device], event: 'callback' }
var b = require('bonescript');
var util = require('util');
var port = ['/dev/i2c-2'];
var backlight = 0x3e;

b.i2cOpen(port, backlight);

b.i2cWriteBytes(port, 0x00, [0x00], function(arg) {
    console.log("arg: " + util.inspect(arg));
});
