#!/usr/bin/env node
// From: https://www.npmjs.com/package/oled-spi

var oled = require('oled-spi');
var font = require('oled-font-5x7');
 
var opts = {
    device: "/dev/spidev2.0",
    width: 64,
    height: 48,
    dcPin: 7,
    rstPin : 20
};
 
var oled = new oled(opts);
oled.begin(function(){
    // do cool oled things here 
    oled.turnOnDisplay();
    oled.clearDisplay();
    // draws 4 white pixels total 
    // format: [x, y, color] 
    oled.drawPixel([
        [32,  16, 1],
        [32,  16+47, 1],
        [32+63, 16, 1],
        [32+63, 16+47, 1],
        [ 1,  1, 1],
        [ 1, 48, 1],
        [64, 1, 1],
        [64,48, 1]
        // [64, 1, 1],
        // [64, 32, 1],
        // [64, 16, 1],
        // [32, 16, 1]
    ]);
    // args: (x0, y0, x1, y1, color) 
    // oled.drawLine(32, 16, 32+63, 16+47, 1);
    // oled.drawLine(32+63, 16, 32, 16+47, 1);
    
    // oled.invertDisplay(true);
    
    oled.fillRect(32+32, 16+24, 10, 20, 1);
    
    // oled.setCursor(1, 1);
    // oled.writeString(font, 1, 'Cats and dogs are really cool animals, you know.', 1, true);
    
    // oled.dimDisplay(true);
    
    // oled.startscroll('left', 0, 15);
});