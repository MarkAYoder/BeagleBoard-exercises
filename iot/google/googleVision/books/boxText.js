#!/usr/bin/env node
// Draws boxes around all letters
// Usage boxText.js frame.jpg frame.json
// frame.json comes from the Google Vision API via getText.js
const fs = require('fs');
const util = require('util');
const exec = require('child_process').exec;

const all = 0; // Set to 1 to mark each letter

var vision  = JSON.parse(fs.readFileSync(process.argv[3]).toString());
var vertices = vision.textAnnotations[0].boundingPoly.vertices;

// console.log(vertices);
var bigBox = " -fill none -stroke green -strokewidth 1 -draw \"polygon ";
for(var j in vertices) {
    bigBox += vertices[j].x + ',' + vertices[j].y + ' ';
}
bigBox += "\" ";
bigBox += "-annotate +0+40 \"" + vision.textAnnotations[0].description + "\" ";
console.log("\n" + vision.textAnnotations[0].description);
var count = vision.textAnnotations[0].description.length;

// console.log(bigBox);

var cmd = "convert " + process.argv[2] + bigBox + " frame.jpg";
            
// console.log(cmd);

console.log("Marking %s charcters", count);

exec(cmd, function(err, stdout, stderr) {
  if (err) {
    console.error("exec err: " + err);
  }
  if(stdout) {
    console.log("stdout: " + stdout);
  }
  if(stderr) {
    console.log("stderr: " + stderr);
  }
});
