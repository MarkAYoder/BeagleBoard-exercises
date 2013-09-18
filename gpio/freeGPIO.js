#!/usr/bin/node
// Lists all gpio pins with MUX UNCLAIMED and GPIO UNCLAIMED in $PINMUX
// Usage:  freeGPIO.js    # List free GPIOs using P8 or P9 pin number
//
// Approach:
//  1. search PINMUX for all entries with "(MUX UNCLAIMED) (GPIO UNCLAIMED)"
//  2. An entry looks like "pin 8 (44e10820): (MUX UNCLAIMED) (GPIO UNCLAIMED)"
//  3. Extract the address (44e10820) and subtract 0x44e10800 to ge the offset
//  4. Format the offset as 0x020, with leading 0's to give 3 digits
//  5. Search for the address in the muxRegOffset field in b.bone.pins
//  6. Print the matching key

var PINMUX = "/sys/kernel/debug/pinctrl/44e10800.pinmux/pinmux-pins",
    b = require('bonescript'),
    exec = require('child_process').exec;

exec('grep "(MUX UNCLAIMED) (GPIO UNCLAIMED)" ' + PINMUX,
            function (error, stdout, stderr) {
                var list,    // Array of unused pins
                    pin,     // pin offset in form 0x020
                    addr,    // pin address, 44e10820
                    keylist = []; // List of all unused header pins, P9_12

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
//                            console.log(b.bone.pins[j].key);
                            keylist.push(b.bone.pins[j].key);
                            break;
                        }
                    }
                }
                keylist.sort();
                console.log(keylist.join(' '));
            });
