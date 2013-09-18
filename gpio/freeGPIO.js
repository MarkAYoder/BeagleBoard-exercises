#!/usr/bin/node
// Lists all gpio pins with MUX UNCLAIMED and GPIO UNCLAIMED in $PINMUX
// Usage:  freeGPIO.js    # List free GPIOs using P8 or P9 pin number

var PINS = "/sys/kernel/debug/pinctrl/44e10800.pinmux/pins",
    PINMUX = "/sys/kernel/debug/pinctrl/44e10800.pinmux/pinmux-pins",
    b = require('bonescript'),
    exec = require('child_process').exec,
    addr;
//    console.log(b.bone.pins);

//    var addr = '(' + (0x44e10800 + 
//                    parseInt(gpio.muxRegOffset, 16)).toString(16) + ')';
    
//    console.log('grep "' + addr + '" ' + PINS);
    exec('grep "(MUX UNCLAIMED) (GPIO UNCLAIMED)" ' + PINMUX,
            function (error, stdout, stderr) {
                var list,    // 
                    pin;

                if(error)  { console.log('error: '  + error ); }
                if(stderr) { console.log('stderr: ' + stderr); }
                
//                console.log(stdout);
                stdout = stdout.substring(0,stdout.length-1);  // Get rid of extra \n
                list = stdout.split('\n');
//                console.log(list);
                for(var i in list) {
                    // list[i] is of form "pin 8 (44e10820): (MUX UNCLAIMED) (GPIO UNCLAIMED)"
                    // Get the address from the 2nd field and remove the ()'s
                    addr = list[i].split(' ')[2].substring(1,9);
                    // Find the offset and return as 0x020, that is, zero padded to 3 digits.
                    pin = '0x' + ('000' + (parseInt(addr,16)-0x44e10800).toString(16)).slice(-3);
//                    console.log(pin + " " + list[i]);
                    for(var j in b.bone.pins) {
                        if (b.bone.pins[j].muxRegOffset === pin) {
                            console.log(b.bone.pins[j].key);
                            break;
                        }
                    }
//                    break;
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

