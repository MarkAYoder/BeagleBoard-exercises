#!/usr/bin/env node
// Turns off and on the LED triggers
var fs = require('fs');
var path = '/sys/class/leds/beaglebone:green:usr';

if(process.argv[2] === 'off') {
    fs.writeFileSync(path+'0/trigger', 'none');
    fs.writeFileSync(path+'1/trigger', 'none');
    fs.writeFileSync(path+'2/trigger', 'none');
    fs.writeFileSync(path+'3/trigger', 'none');
//    fs.writeFileSync('/sys/class/leds/wifi/brightness', '0');
//    fs.writeFileSync('/sys/class/gpio/gpio49/value', '0');
} else {
    fs.writeFileSync(path+'0/trigger', 'heartbeat');
    fs.writeFileSync(path+'1/trigger', 'mmc0');
    fs.writeFileSync(path+'2/trigger', 'cpu0');
    fs.writeFileSync(path+'3/trigger', 'mmc1');
//    fs.writeFileSync('/sys/class/gpio/gpio49/value', '1');
}
