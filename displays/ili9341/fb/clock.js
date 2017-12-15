#!/usr/bin/env node
// Generates imagemagick commands to draw a clock face
const util = require('util');
// const b    = require('bonescript');

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

// setTimeout(displayTime, 1000);

displayTime();

function displayTime() {
    const d = new Date();
    console.log("Seconds: " + d.getSeconds());
    
    var ang = Math.PI/2-2*Math.PI*d.getSeconds()/60;
    var currentCmd = cmd + util.format("line %d,%d %d,%d\n", xcent, ycent, 
            xcent+rad*Math.cos(ang), ycent-rad*Math.sin(ang));
    
    ang = Math.PI/2-2*Math.PI*d.getMinutes()/60;
    var minScale = 0.8;
    currentCmd = currentCmd + util.format("line %d,%d %d,%d\n", xcent, ycent, 
            xcent+minScale*rad*Math.cos(ang), ycent-minScale*rad*Math.sin(ang));
    
    ang = Math.PI/2-2*Math.PI*d.getHours()/12;
    var hourScale = 0.5;
    currentCmd = currentCmd + util.format("line %d,%d %d,%d\n", xcent, ycent, 
            xcent+hourScale*rad*Math.cos(ang), ycent-hourScale*rad*Math.sin(ang));
    
    currentCmd +=  "\" " + TMP_FILE + "; ";
    
    // currentCmd += "sudo fbi -noverbose -T 1 " + TMP_FILE;
    // currentCmd += "gnome-open " + TMP_FILE;
    // currentCmd += "ffmpeg -i " + TMP_FILE + " -vcodec rawvideo -f rawvideo -pix_fmt rgb565 -y /dev/fb0";
    
    // console.log(currentCmd);
    
    const exec = require('child_process').exec;
    exec(currentCmd, {timeout: 1000}, (error, stdout, stderr) => {
      if (error) {
        console.error(`exec error: ${error}`);
        return;
      }
      if(stdout) console.log(`stdout: ${stdout}`);
    //   if(stderr) console.log(`stderr: ${stderr}`);
      // setTimeout(displayTime, 1000);
    });
    
}

// ffmpeg -i /tmp/frame.png -vcodec rawvideo -f rawvideo -pix_fmt rgb565 -y /dev/fb0