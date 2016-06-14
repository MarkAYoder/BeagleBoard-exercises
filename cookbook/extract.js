#!/usr/bin/env node
// Extracts the Problem and Solution sections from the BeagleBone Cookbook
// Mark A. Yoder
// From:  https://nodejs.org/api/readline.html#readline_example_read_file_stream_line_by_line
// Usage:  extrac.js inputFile outputFile
const readline = require('readline');
const fs = require('fs');

console.log(process.argv);

var inputFile  = process.argv[2];
var outputFile = process.argv[3];
fs.writeFileSync(outputFile, '');
var save = false;
var state = 'start';

const rl = readline.createInterface({
    input: fs.createReadStream(inputFile)
});

rl.on('line', function (line) {
    switch(state) {
        case 'start':
            if(line.match(/^=== Introduction/)) {
                console.log("Found Introduction");
                save = false;
                state = 'intro';
            }
            break;
            
        case 'intro':
            if(line.match(/^=== /)) {
                console.log("Found " + line);
                save = true;
                state = 'title';
            }
            break;
            
        case 'title':
            if(line.match(/^==== Problem/)) {
                console.log("Found Problem");
                save = true;
                state = 'prob';
            }
            break;
            
        case 'prob':
            if(line.match(/^==== Solution/)) {
                console.log("Found Solution");
                save = true;
                state = 'sol';
            }
            break;
            
        case 'sol':
            if(line.match(/^image:/)) {
                console.log("Found " + line);
            }
            if(line.match(/^==== Discussion/)) {
                console.log("Found Discussion");
                save = false;
                state = 'intro';
            }
            break;
    }
    if(save) {
        // console.log("Saving: " +line);
        fs.appendFileSync(outputFile, line+'\n');
    }
    // console.log('Line from file:', line);
});