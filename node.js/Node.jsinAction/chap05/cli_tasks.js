var fs = require('fs')
  , path = require('path')
  , args = process.argv.splice(2)
  , command = args.shift()
  , taskDescription = args.join(' ')
  , file = path.join(process.cwd(), '/.tasks');

switch(command) {
  case 'list':
    listTasks(file);
    break;

  case 'add':
    addTask(file, taskDescription);
    break;

  default:
    console.log('Usage: ' + process.argv[0]
      + ' list|add [taskDescription]');
}

function listTasks(file) {
  getTasks(file, function(tasks) {
    for(var i in tasks) {
      console.log(tasks[i]);
    }
  });
}

function addTask(file, taskDescription) {
  getTasks(file, function(tasks) {
    tasks.push(taskDescription);
    storeTasks(file, tasks);
  });
}

function storeTasks(file, tasks) {
  fs.writeFile(file, JSON.stringify(tasks), 'utf8', function(err) {
    if (err) throw err;
    console.log('Saved.');
  });
}

function getTasks(file, cb) {
  path.exists(file, function(exists) {
    var tasks = [];
    if (exists) {
      fs.readFile(file, 'utf8', function(err, data) {
        if (err) throw err;
        var data = data.toString();
        var tasks = JSON.parse(data);
//        console.log('====\ntasks\n====\n');
//        console.log(tasks);
        cb(tasks);
      });
    } else {
      cb([]);
    }
  });
}
