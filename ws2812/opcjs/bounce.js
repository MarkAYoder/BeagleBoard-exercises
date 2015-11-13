#!/usr/bin/env node
// This is for three 10x10 grids

var opc_client = require('open-pixel-control');
var b = require('bonescript');

var xlen = 30,    // Size of virtual grid
    xlenR= 10,    // Size of real grid
    ylen = 10,
    xdir = 1,     // Direction ball is traveling
    ydir = -1,
    colorL = [127, 0, 0],  // Color of ball (RGB)
    colorR = [0, 0, 127],  // Color of ball (RGB)
    color  = colorL,
    bgnd = [0, 40, 0],     // Color of background
    grid = new Array(xlen*ylen),  // Playing field
    ms   = 100;   // Time (in ms) between moves

var x = 0,        // Current location
    y = 5;
    
// Initialize the grid of LEDs
for(var i=0; i<grid.length; i++) {
  grid[i] = bgnd;
}

// Connect to opc client
var client = new opc_client({
  address: 'localhost',
  port: 7890
});

client.on('connected', function() {   // Do this connected
  console.log("Connected");
  var strip = client.add_strip({
    length: xlen*ylen
  });

// This maps the virtual address to the location in grid
  function gi(x, y) {
    var tmp = y*ylen + Math.floor(x/xlenR)*xlenR*ylen+x%xlenR;
    // console.log("x=%d, y=%d, ret=%d", x, y, tmp);
    return tmp;
  }
  
// Here's how you move the ball
  function moveBall() {
    grid[gi(x,y)] = bgnd;    // Turn off ball in present location
    x += xdir;                // Move in the current direction
    y += ydir;
    if(x<0 || x>xlen-1) {
      xdir = -xdir;
      x += xdir;
    }
    if(y<0 || y>ylen-1) {
      ydir = -ydir;
      y += ydir;
    }

    grid[gi(x,y)] = color;   // Draw ball in new location
    client.put_pixels(strip.id, grid);  // Display the grid
    setTimeout(moveBall, ms); // Schedule the next ball move
  }
  
  moveBall(); // Start the ball moving
  
});

client.connect(); // Connect to the OPC server and start things moving
