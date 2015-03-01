#!/usr/bin/env node
// From: https://www.npmjs.com/package/opc
// Create TCP connection to Open Pixel Control server 
var Socket = require("net").Socket;
var socket = new Socket();
socket.setNoDelay();
socket.connect(7890);
 
// Create an Open Pixel Control stream and pipe it to the server 
var createOPCStream = require("opc");
var stream = createOPCStream();
stream.pipe(socket);
 
// Create a strand representing connected lights
// console.log("Creating strand");
var createStrand = require("opc/strand");
var strand = createStrand(100); // Fadecandy has 512 addresses 
// var left = strand.slice(0, 50); // Fadecandy pin 0 
// var right = strand.slice(50, 100); // Fadecand pin 1 
// Set all left pixels to red and right to blue

var pixel = 0;
setOne();
    
function setOne() {
    for (var i = 0; i < 100; i++) {
      strand.setPixel(i, 0, 0, 0);
    }
    strand.setPixel(pixel, 127, 127, 127);
    pixel++;
    if(pixel<100) {
        setTimeout(setOne, 50);
    }
    stream.writePixels(0, strand.buffer);
}
     
// Write the pixel colors to the device on channel 0 

// stream.end();