#!/usr/bin/env node

var opc_client = require('open-pixel-control');
var b = require('bonescript');

// Size of grid
var xlen = 10,
    ylen = 10,
    xpos = xlen/2,
    ypos = ylen/2+1,
    xdir = 1,
    ydir = -1,
    color = [127, 0, 0],
    bgnd = [0, 0, 0],
    grid = new Array(xlen*ylen),
    ms   = 300,
    pin  = 'P9_42';
    
var x = 0,
    y = ylen/2;
    
b.pinMode(pin, b.INPUT);

b.attachInterrupt(pin, true, b.RISING, reverse);

function reverse() {
  console.log("reverse");;;;;;;;
  
  if(x<2 || x>xlen-2) {
  xdir = -xdir;
  }
}

// Set up grid of LEDs
for(var i=0; i<grid.length; i++) {
  grid[i] = bgnd;
}

var client = new opc_client({
  address: 'localhost',
  port: 7890
});

client.on('connected', function(){
  console.log("Connected");
  var strip = client.add_strip({
    length: xlen*ylen
  });

  client.put_pixels(strip.id, grid);
  
  movePixel();
  
  function movePixel() {
    // client.put_pixel(strip.id, x*xlen+y, bgnd);
    grid[x*xlen+y] = bgnd;
    x += xdir;
    if(x<0 || x>=xlen) {
      // xdir = -xdir;
      // x += xdir;
      x = xlen/2;
    }
    // client.put_pixel(strip.id, x*xlen+y, color);
    grid[x*xlen+y] = color;
    client.put_pixels(strip.id, grid);
    setTimeout(movePixel, ms);
  }
  
  // client.disconnect();

});

client.connect();
