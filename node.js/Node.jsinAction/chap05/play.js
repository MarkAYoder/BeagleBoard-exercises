var fs = require('fs')
  , path = require('path')
  , args = process.argv.splice(2)
  , command = args.shift()
  , taskDescription = args.join(' ')
  , file = path.join(process.cwd(), '/.tasks');

console.log('====\n process.argc\n====\n');
console.log(process.argv);
console.log('====\n path\n====\n');
console.log(path);
console.log('====\n fs\n====\n');
console.log(fs);
console.log('====\n console\n====\n');
console.log(console);

