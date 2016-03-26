#!/usr/bin/env node

var request = require('request');
var cheerio = require('cheerio');
const zlib = require('zlib');

// Get ink status on hp Printer at home
var url = 'https://hpprinter/#hId-pgInkConsumables';
// http://stackoverflow.com/questions/20433287/node-js-request-cert-has-expired#answer-29397100
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

request(url, function(err, response, html) {
	if(err) {
		console.log("err: " + err)
	} else {
		console.log("response: " + JSON.stringify(response));
		// console.log(html);
		// console.log("html: " + html);
		var $ = cheerio.load(html);

		const buffer = new Buffer(html, 'base64');
		console.log("buffer: " + buffer);
		zlib.gunzip(buffer, function(err, buffer) {
		  if (!err) {
		    console.log("buffer: " + buffer.toString());
		  } else {
		    console.log("err: " + err);
		  }
		});

		$('.staticProp').filter(function(){
	        var data = $(this);
	        // console.log("data: " + data);
	        // Find path to Tray 1 status
	        var path = data.children().first().children().first().children().first().children();
	        // console.log("path: " + path);
	        var tray = path.eq(0).text();
	        if(tray.indexOf("Tray") > -1) {
	        	var status = path.eq(1).children().first().children().first().children().first().children().first().attr('title');
	        	var size   = path.eq(3).children().first().children().first().children().first().text();
		        console.log("tray:   " + tray);
		        console.log("status: " + status);
		        console.log("size:   " + size);
	        }
        });
	}
});



// const input = '.................................';
// zlib.deflate(input, function(err, buffer) {
//   if (!err) {
//     console.log(buffer.toString('base64'));
//   } else {
//     console.log("err: " + err);
//   }
// });

// const buffer = new Buffer('eJzT0yMAAGTvBe8=', 'base64');
// zlib.unzip(buffer, function(err, buffer) {
//   if (!err) {
//     console.log(buffer.toString());
//   } else {
//     console.log("err: " + err);
//   }
// });