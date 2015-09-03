#!/usr/bin/env node

// Simple command line etch-a-sketch framework.

var util = require('util');

var xMax = 8,
    yMax = 8;
var grid = new Array(yMax);
var x=0,	// Current position
    y=0;

// Initialize th grid to all blanks
for(var i=0; i<grid.length; i++) {
    grid[i] = new Array(xMax);
    for(var j=0; j<grid[i].length; j++) {
	grid[i][j] = ' ';
    }
}

// Show a + at the current location
grid[y][x] = '+';

// Print the grid
function printGrid(grid) {
  util.print('   0 1 2 3 4 5 6 7\n');
  for(var i=0; i<grid.length; i++) {
    util.print(util.format("%d: ",i));
    for(var j=0; j<grid[i].length; j++) {
      util.print(util.format("%s ", grid[i][j]));
    }
  util.print("\n");
  }
}

printGrid(grid);

// This set up the handlers to read user input.
var readline = require('readline'),
    rl = readline.createInterface(process.stdin, process.stdout);

rl.setPrompt('Direction> ');
rl.prompt();

// This function is called whenever a newline is entered
rl.on('line', function(line) {
  grid[y][x] = '*';
  switch(line.trim()) {
    case 'u':
      console.log('Up!');
      y--;
      if(y<0) {y=grid.length-1;}
      break;
    case 'd':
      console.log('Down!');
      y++;
      if(y >= grid.length) {y=0;}
      break;
    case 'l':
      console.log('Left!');
      x--;
      if(x<0) {x = grid[y].length-1;}
      break;
    case 'r':
      console.log('Right!');
      x++;
      if(x >= grid[y].length) {x=0;}
      break;
    default:
      console.log('Say what? I might have heard `' + line.trim() + '`');
      break;
  }
  grid[y][x] = '+';
  printGrid(grid);
  rl.prompt();
}).on('close', function() {
  console.log('Have a great day!');
  process.exit(0);
});

