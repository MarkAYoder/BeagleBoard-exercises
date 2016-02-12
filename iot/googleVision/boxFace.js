#!/usr/bin/env node
// Draws boxes around faces
var fs = require('fs');

var vision  = JSON.parse(fs.readFileSync(process.argv[3]).toString());
var faces = vision.faceAnnotations;

// console.log(vision.faceAnnotations[0].boundingPoly);

var coordinates = "";
for(var i in faces) {
    var vertices = faces[i].boundingPoly.vertices;
    var coord = "-draw \"polygon ";
    for(var j in vertices) {
        coord += vertices[j].x + ',' + vertices[j].y + ' ';
    }
    coordinates += coord + "\" ";
    // console.log(vertices);
    console.log(coordinates);
}
console.log("convert %s -fill none -stroke black -strokewidth 3 "
    + "%s tmp.jpg", process.argv[2], coordinates);