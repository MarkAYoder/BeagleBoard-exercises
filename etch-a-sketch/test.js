// I'm testing out 2D arrays

var util = require('util');

var grid = new Array(8);
var x=0,
    y=0;

for(var i=0; i<grid.length; i++) {
    grid[i] = new Array(8);
    for(var j=0; j<grid[i].length; j++) {
	grid[i][j] = ' ';
    }
}

grid[y][x] = '*';

function printGrid(grid) {
  util.print('   0 1 2 3 4 5 6 7\n');
  for(var i=0; i<8; i++) {
    util.print(util.format("%d: ",i));
    for(var j=0; j<8; j++) {
      util.print(util.format("%s ", grid[i][j]));
    }
  util.print("\n");
  }
}

printGrid(grid);

var readline = require('readline'),
    rl = readline.createInterface(process.stdin, process.stdout);

rl.setPrompt('Direction> ');
rl.prompt();

rl.on('line', function(line) {
  switch(line.trim()) {
    case 'u':
      console.log('Up!');
      break;
    case 'd':
      console.log('Down!');
      y++;
      break;
    case 'l':
      console.log('Left!');
      break;
    case 'r':
      console.log('Right!');
      break;
    default:
      console.log('Say what? I might have heard `' + line.trim() + '`');
      break;
  }
  grid[y][x] = '*';
  printGrid(grid);
  rl.prompt();
}).on('close', function() {
  console.log('Have a great day!');
  process.exit(0);
});

