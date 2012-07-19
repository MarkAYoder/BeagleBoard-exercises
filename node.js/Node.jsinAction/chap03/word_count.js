//From page 66 of Node.js in Action

var fs = require('fs'),
    completedTasks = 0,
    tasks = [],
    wordCounts = {},
    filesDir = './text';

function checkIfComplete() {
    "use strict";
    var index;
//    console.log("checkIfComplete()");
    completedTasks += 1;
    if (completedTasks === tasks.length) {
        for (index in wordCounts) {
            console.log(index + ': ' + wordCounts[index]);
        }
    }
}

function countWordsInText(text) {
    "use strict";
    var words = text
        .toString()
        .toLowerCase()
        .split(/\W+/)
        .sort(),
        index,
        word;
//    console.log("words: " + words);
    for (index in words) {
        word = words[index];
        if (word) {
            wordCounts[word] = (wordCounts[word]) ? wordCounts[word] + 1 : 1;
        }
//        console.log("wordCounts: " + wordCounts);
    }
}

fs.readdir(filesDir, function (err, files) {
    "use strict";
    var index,
        task;
//    console.log("files: " + files);
    if (err) {throw err; }
    for (index in files) {
//        console.log("index: " + index);
        task = (function (file) {
            return function () {
                fs.readFile(file, function (err, text) {
                    if (err) {throw err; }
                    countWordsInText(text);
                    checkIfComplete();
                });
            };
        }(filesDir + '/' + files[index]));
        tasks.push(task);
//        console.log("tasks: " + tasks);
    }
    for (task in tasks) {
        tasks[task]();
    }
});

