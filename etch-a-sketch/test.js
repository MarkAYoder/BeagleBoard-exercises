// I'm testing out 2D arrays

var util = require('util');

var grid = new Array(8);

for(var i=0; i<grid.length; i++) {
    grid[i] = new Array(8);
    for(var j=0; j<grid[i].length; j++) {
	grid[i][j] = '*';
    }
}

//grid[0][0] = 0;

for(var i=0; i<8; i++) {
    util.print(util.format("%d: ",i));
    for(var j=0; j<8; j++) {
	util.print(util.format("%s ", grid[i][j]));
    }
    util.print("\n");
}

