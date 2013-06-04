//etch-a-sketch via rotary encoders

// Tests the rotary encoder function

var b = require('bonescript');
var pinA1 = 'P9_30',
    pinB1 = 'P9_27',
    pinA2 = 'P9_26',
    pinB2 = 'P9_24';
    
var rre = require('./readRotaryEncoder.js');

rre.readRotaryEncoder(pinA1, pinB1, upCallback,   downCallback);
rre.readRotaryEncoder(pinA2, pinB2, leftCallback, rightCallback);

setTimeout(detach, 30000);

function detach() {
 b.detachInterrupt(pinA1);
 b.detachInterrupt(pinB1);
 console.log("All Done!");
}

var util = require('util');

var xMax = 8,
    yMax = 8;
var grid = new Array(yMax);
var x=0,    // Current position
    y=0;

// Initialize the grid to all blanks
for (var i = 0; i < grid.length; i++) {
	grid[i] = new Array(xMax);
	for (var j = 0; j < grid[i].length; j++) {
		grid[i][j] = ' ';
	}
}

// Print the grid
function printGrid(grid) {
	util.print('   0 1 2 3 4 5 6 7\n');
	for (var i = 0; i < grid.length; i++) {
		util.print(util.format("%d: ", i));
		for (var j = 0; j < grid[i].length; j++) {
			util.print(util.format("%s ", grid[i][j]));
		}
		util.print("\n");
	}
}

// Print the grid to get things going
postCallback();

function preCallback() {
      grid[y][x] = '*';
}
function postCallback() {
	grid[y][x] = '+';
	printGrid(grid);
}
function upCallback() {
	console.log('Turned Up');
	preCallback();
	y--;
	if (y < 0) {
		y = grid.length - 1;
	}
	postCallback();
}
function downCallback() {
	console.log('Turned Down');
    preCallback();
	y++;
	if (y >= grid.length) {
		y = 0;
	}
    postCallback();
}
function leftCallback() {
	console.log('Turned Left');
    preCallback();
	x--;
	if (x < 0) {
		x = grid[y].length - 1;
	}
    postCallback();
}
function rightCallback() {
	console.log('Turned Right');
    preCallback();
	x++;
	if (x >= grid[y].length) {
		x = 0;
	}
    postCallback();
}
