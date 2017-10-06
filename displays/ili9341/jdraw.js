#!/usr/bin/env node
// Generates imagemagick commands to draw a clock face
const util = require('util');

const TMP_FILE = '/tmp/frame.png';

const xmax = 320;   // Display size
const ymax = 240;

const xcent = xmax/2;   // Put center in middle of display
const ycent = ymax/2;

const rad = 100;
const len = 10;     // length of tics

var ang = 0;
var cmd = '';

cmd = util.format("convert -size %dx%d xc:skyblue -fill white -stroke black \\\n",
        xmax, ymax);
cmd += "-draw \"\n";
cmd += util.format("circle %d,%d %d,%d\n", xcent, ycent, xcent, ycent-rad);

// Draw the ticks around the face
for(ang=0; ang<2*Math.PI; ang+=Math.PI/6) {
    cmd += util.format("line %d,%d %d,%d\n", xcent+rad*Math.cos(ang), ycent+rad*Math.sin(ang), 
        xcent+(rad-len)*Math.cos(ang), ycent+(rad-len)*Math.sin(ang));
}

// Draw second hand

const d = new Date();
const sec = d.getSeconds();
console.log("Seconds: " + sec);

ang = Math.PI/2-2*Math.PI*sec/60;
cmd += util.format("line %d,%d %d,%d\n", xcent, ycent, xcent+rad*Math.cos(ang), ycent-rad*Math.sin(ang));

cmd +=  "\" " + TMP_FILE + "; ";

// cmd += "sudo fbi -noverbose -T 1 " + TMP_FILE;
cmd += "gnome-open " + TMP_FILE;

console.log(cmd);

const exec = require('child_process').exec;
exec(cmd, (error, stdout, stderr) => {
  if (error) {
    console.error(`exec error: ${error}`);
    return;
  }
  if(stdout) console.log(`stdout: ${stdout}`);
  if(stderr) console.log(`stderr: ${stderr}`);
});
