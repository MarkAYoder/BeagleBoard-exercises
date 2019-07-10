#!/usr/bin/env node
// Turns off and on the LED triggers
var fs = require('fs');
var path = '/sys/class/leds/beaglebone:green:usr';

if(process.argv[2] === 'off') {
    fs.writeFile(path+'0/trigger', 'none');
    fs.writeFile(path+'1/trigger', 'none');
    fs.writeFile(path+'2/trigger', 'none');
    fs.writeFile(path+'3/trigger', 'none');
//    fs.writeFile('/sys/class/leds/wifi/brightness', '0');
//    fs.writeFile('/sys/class/gpio/gpio49/value', '0');
} else {
    fs.writeFile(path+'0/trigger', 'heartbeat');
    fs.writeFile(path+'1/trigger', 'mmc0');
    fs.writeFile(path+'2/trigger', 'cpu0');
    fs.writeFile(path+'3/trigger', 'mmc1');
//    fs.writeFile('/sys/class/gpio/gpio49/value', '1');
}
