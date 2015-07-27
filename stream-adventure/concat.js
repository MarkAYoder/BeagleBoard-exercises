#!/usr/bin/env node

var fs=require('fs');
var concat = require('concat-stream');

process.stdin
    .pipe(concat(function(body) {
        var tmp = body.toString().split('').reverse().join('');
        console.log(tmp);
    }));
