#!/bin/node

var exec = require('child_process').exec;

function speakForSelf(phrase) {
	exec(__dirname + '/speak.sh ' + phrase, function(error, stdout, stderr) {
		console.log('stdout: ' + stdout);
		console.log('stderr: ' + stderr);
		if (error !== null) {
			console.log('exec error: ' + error);
		}
	});
}

speakForSelf("Hello, my name is Borris.");