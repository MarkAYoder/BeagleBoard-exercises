#!/usr/bin/env node
// From: https://www.npmjs.com/package/oled-spi

var oled = require('oled-spi');
 
var opts = {
    device: "/dev/spidev2.0",
    width: 128,
    height: 64,
    dcPin: 7,
    rstPin : 20
};
 
var oled = new oled(opts);
oled.begin(function(){
    // do cool oled things here 
    oled.turnOnDisplay();
    // draws 4 white pixels total 
    // format: [x, y, color] 
    oled.drawPixel([
        [128, 1, 1],
        [128, 32, 1],
        [128, 16, 1],
        [64, 16, 1]
    ]);
  
});