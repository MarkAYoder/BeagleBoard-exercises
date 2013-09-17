#!/usr/bin/node
// Lists all gpio pins with MUX UNCLAIMED and GPIO UNCLAIMED in $PINMUX
// Usage:  freeGPIO.js    # List free GPIOs using P8 or P9 pin number

var PINS = "/sys/kernel/debug/pinctrl/44e10800.pinmux/pins",
    PINMUX = "/sys/kernel/debug/pinctrl/44e10800.pinmux/pinmux-pins",
    b = require('bonescript'),
    exec = require('child_process').exec,
    addr;

//    var addr = '(' + (0x44e10800 + 
//                    parseInt(gpio.muxRegOffset, 16)).toString(16) + ')';
    
//    console.log('grep "' + addr + '" ' + PINS);
    exec('grep "(MUX UNCLAIMED) (GPIO UNCLAIMED)" ' + PINMUX,
            function (error, stdout, stderr) {
                var list;    // Direction of pullup or pulldown

                if(error) { console.log('error: ' + error); }
                if(stderr) {console.log('stderr: ' + stderr); }
                
//                console.log(stdout);
                stdout = stdout.substring(0,stdout.length-1);  // Get rid of extra \n
                list = stdout.split('\n');
//                console.log(list);
                for(var i in list) {
                    addr = list[i].split(' ')[2].substring(1,9);
                    console.log(addr);
                }
            });
/*
    exec('grep "' + addr + '" ' + PINMUX,
            function (error, stdout, stderr) {

                if(error) { console.log('error: ' + error); }
                if(stderr) {console.log('stderr: ' + stderr); }
                
                console.log(stdout);
            });
            */

/*
var gpio = process.argv[2].toUpperCase();
if (gpio[0] === 'P') {
    console.log(b.bone.pins[gpio]);
    pinMux(b.bone.pins[gpio]);
} else {
	console.log("Looking for gpio " + gpio);
	for (var i in b.bone.pins) {
		if (b.bone.pins[i].gpio === parseInt(gpio,10)) {
			console.log(b.bone.pins[i]);
            pinMux(b.bone.pins[i]);
		}
	}
    */

