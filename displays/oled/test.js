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
        [ 32,  16, 1],
        [ 32,  16+47, 1],
        [ 32+63, 16, 1],
        [ 32+63, 16+47, 1]
        // [64, 1, 1],
        // [64, 32, 1],
        // [64, 16, 1],
        // [32, 16, 1]
    ]);
    // // args: (x0, y0, x1, y1, color) 
    // oled.drawLine(1, 1, 64, 48, 1);
    
    // // oled.invertDisplay(true);
    
    // oled.fillRect(1, 1, 10, 20, 1);
});