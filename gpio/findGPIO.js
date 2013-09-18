#!/usr/bin/node
// Program to test looking up information in /usr/share/bone101/static/bone.js
// Usage:  findGPIO.js 7     # Look up info for gpio7 (internal pin number)
//         findGPIO.js P9_12 # Look up using header pin number (external)
// Returns current pin mux

var PINS = "/sys/kernel/debug/pinctrl/44e10800.pinmux/pins",
    PINMUX = "/sys/kernel/debug/pinctrl/44e10800.pinmux/pinmux-pins",
    b = require('bonescript'),
    exec = require('child_process').exec;

/*
process.argv.forEach(function(val, index, array) {
	console.log(index + ': ' + val);
});
*/

function pinMux(gpio) {
    var addr = '(' + (0x44e10800 + 
                    parseInt(gpio.muxRegOffset, 16)).toString(16) + ')';
    
//    console.log('grep "' + addr + '" ' + PINS);
    exec('grep "' + addr + '" ' + PINS,
            function (error, stdout, stderr) {
                var mux,    // Current mux setting
                    out,   // output string
                    dir = 'down';    // Direction of pullup or pulldown

                if(error) { console.log('error: ' + error); }
                if(stderr) {console.log('stderr: ' + stderr); }
                
                stdout = stdout.substring(0,stdout.length-1);  // Get rid of extra \n
                console.log(stdout);
                mux = parseInt(stdout.split(" ")[3], 16);  // Get the mux field
                out = "Mode: " + (mux & 0x7) + " (" + gpio.options[mux & 0x7] + ")";
                if(!(mux & 0x8)) {   // Pullup or down is enabled
                    if(mux & 0x10) {
                        dir = 'up';
                    }
                    out += ' pull' + dir;
                }
                if(mux & 0x20) {
                    out += " Receiver Active";
                }
                if(mux & 0x40) {
                    out += " Slew Control Slow";
                }
                console.log(out);
            });

    exec('grep "' + addr + '" ' + PINMUX,
            function (error, stdout, stderr) {

                if(error) { console.log('error: ' + error); }
                if(stderr) {console.log('stderr: ' + stderr); }
                
                console.log(stdout);
            });
}

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
}
