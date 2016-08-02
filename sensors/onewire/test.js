#!/usr/bin/env node
var b = require('bonescript');

var w1="/sys/bus/w1/devices/28-0000074b85ea/w1_slave"

setInterval(getTemp, 1000);	// read temperatue every 1000ms

function getTemp() {
    b.readTextFile(w1, printStatus);
}

function printStatus(x) {
    if(x.err) {
        console.log('x.err  = ' + x.err);
    } else {
        console.log('x.data = ' + x.data);
        var temp = x.data.slice(x.data.indexOf('t=')+2, -1);
        console.log('temp = ' + temp);
        temp = temp.slice(0,2) + '.' + temp.slice(2);
        console.log('temp = ' + temp);
        console.log('temp = ' + (temp*9/5+32).toFixed(1));
    }
}
