#!/usr/bin/env node
var b = require('bonescript');
var port = '/dev/i2c-2';
var backlight = 0x3e;

b.i2cOpen(port, backlight);

b.i2cWriteBytes(port, 0x00, [0x00]);
