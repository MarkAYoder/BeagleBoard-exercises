#!/usr/bin/env node
// From: https://learn.adafruit.com/adafruit-io-basics-digital-input/raspberry-pi-wifi
// I used P8_19 which is gpio 22 for the switch
// and P9_14 for the LED

var GpioStream = require('gpio-stream'),
    light = GpioStream.writable(50),
    AIO = require('adafruit-io');


// replace xxxxxxxxxxx with your Adafruit IO key
var AIO_KEY      = process.env.AIO_KEY,
    AIO_USERNAME = process.env.AIO_USER;

// aio init
var aio = AIO(AIO_USERNAME, AIO_KEY);

// pipe light data to the powerswitch tail
aio.feeds('Light').pipe(light);

console.log('listening for light data...');
