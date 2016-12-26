#!/usr/bin/env node
// Draws boxes around faces
var fs = require('fs');
var util = require('util');

var vision  = JSON.parse(fs.readFileSync(process.argv[3]).toString());
var text = vision.textAnnotations;

console.log(vision.textAnnotations[0].boundingPoly);

// console.log(vision.fullTextAnnotation.pages[0].blocks[0].paragraphs[0].words[0].symbols);

var coordinates = "";
var pages = vision.fullTextAnnotation.pages;
for(var p in pages) {
    // console.log("page[%d] = " + pages[p], p);
    var blocks = pages[p].blocks;
    for(var b in blocks) {
        // console.log("block[%d] = " + blocks[b], b);
        var paragraphs = blocks[b].paragraphs;
        for(var pg in paragraphs) {
            // console.log("paragraph[%d] = " + paragraphs[pg], pg);
            var words = paragraphs[pg].words;
            for(var w in words) {
                // console.log("word[%d] = " + words[w], w);
                var symbols = words[w].symbols;
                for(var s in symbols) {
                    // console.log("symbol[%d] = " + util.inspect(symbols[s]), s);
                    // console.log("text: %s, boundingBox: " + symbols[s].boundingBox, symbols[s].text);
                    var vertices = symbols[s].boundingBox.vertices;
                    var coord = "-draw \"polygon ";
                    for(var j in vertices) {
                        coord += vertices[j].x + ',' + vertices[j].y + ' ';
                    }
                    coordinates += coord + "\" -pointsize 28 -annotate +" + (vertices[0].x+20.0) + "+" + (vertices[0].y+60.0) + " ";
                    coordinates += "'"+symbols[s].text+"' ";
                    // console.log(vertices);
                    // console.log(coordinates);
                }
            }
        }
    }
}
console.log("convert %s -fill none -stroke black -strokewidth 3 "
    + "%s "
    + "tmp.jpg", process.argv[2], coordinates);

// var coordinates = "";
// for(var i in text) {
//     var vertices = text[i].boundingPoly.vertices;
//     var coord = "-draw \"polygon ";
//     for(var j in vertices) {
//         coord += vertices[j].x + ',' + vertices[j].y + ' ';
//     }
//     coordinates += coord + "\" -pointsize 24 -annotate +" + vertices[3].x + "+" + vertices[3].y + " ";
//     coordinates += "'\ntext: "+text[i].description+"' ";
//     // console.log(vertices);
//     console.log(coordinates);
// }
