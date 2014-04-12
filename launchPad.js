#!/usr/bin/env node
// From: https://github.com/jamesp/node-nmea

// Need to add exports.serialParsers = m.module.parsers;
// to /usr/local/lib/node_modules/bonescript/serial.js

var b = require('bonescript');

var port = '/dev/ttyO1';
var options = {
    baudrate: 9600,
    parser: b.serialParsers.readline("\n")
};

b.serialOpen(port, options, onSerial);


function onSerial(x) {
    console.log(x.event);
    if (x.err) {
        console.log('***ERROR*** ' + JSON.stringify(x));
    }
    if (x.event == 'open') {
        console.log('***OPENED***');
        setInterval(sendCommand, 1000);
    }
    if (x.event == 'data') {
        console.log(String(x.data));
    }
}

var command = ['r', 'R', 'g', 'G'];
var commIdx = 1;

function sendCommand() {
    // console.log('Command: ' + command[commIdx]);
    b.serialWrite(port, command[commIdx++]);
    if(commIdx >= command.length) {
        commIdx = 0;
    }
}