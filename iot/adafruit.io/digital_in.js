#!/usr/bin/env node
// From: https://learn.adafruit.com/adafruit-io-basics-digital-input/raspberry-pi-wifi
// I used P8_19 which is gpio 22 for the switch
// and P9_14 for the LED

var GpioStream = require('gpio-stream'),
    button = GpioStream.readable(22),       // P8_18 on Bone - attach switch
    led = GpioStream.writable(50),          // P9_14 - attach an LED
    AIO = require('adafruit-io');

// replace xxxxxxxxxxx with your Adafruit IO key
var AIO_KEY = process.env.AIO_KEY,
    AIO_USERNAME = process.env.AIO_USER;

// aio init
var aio = AIO(AIO_USERNAME, AIO_KEY);

// pipe button presses to the button feed
button.pipe(aio.feeds('Button'));
button.pipe(process.stdout);
button.pipe(led);

console.log('listening for button presses...');
