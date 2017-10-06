#!/usr/bin/env node
// Generates imagemagick commands to draw a clock face
const util = require('util');

const xmax = 320;   // Display size
const ymax = 240;

const xcent = xmax/2;   // Put center in middle of display
const ycent = ymax/2;

const rad = 100;
const len = 10;     // length of tics

var ang = 0;

console.log("convert -size $SIZE xc:skyblue -fill white -stroke black \\");
console.log("-draw \"");
console.log(util.format("circle %d,%d %d,%d", xcent, ycent, xcent, ycent-rad));

// Draw the ticks around the face
for(ang=0; ang<2*Math.PI; ang+=Math.PI/6) {
    console.log(util.format("line %d,%d %d,%d", xcent+rad*Math.cos(ang), ycent+rad*Math.sin(ang), 
        xcent+(rad-len)*Math.cos(ang), ycent+(rad-len)*Math.sin(ang)));
}



console.log("\" $TMP_FILE");