#!/usr/bin/env node
// Reads the big Ricoh printer in the workroom

var request = require('request');
var cheerio = require('cheerio');

// Let's scrape c205
var url = 'http://c205-ricoh.printer.rose-hulman.edu/web/guest/en/websys/webArch/getStatus.cgi';

request(url, function(error, response, html) {
	if(!error){
		// console.log("html: " + html);
		var $ = cheerio.load(html);

		$('.listboxS').filter(function() {
	        var data = $(this);
	        // console.log("data: " + data);
	        // Find path to Tray 1 status
	        var path = data.children().eq(2).children().first().children().first().children();
	        // console.log("path: " + path);
	        var tray = path.eq(0).text();
	        // console.log("tray: " + tray);
	        if(tray.indexOf("Tray 3") > -1) {
	        	var status = path.eq(1).children().eq(0).attr('title');
	        	var size   = path.eq(1).text();
		        console.log("tray:   " + tray);
		        console.log("status: " + status);
		        console.log("size:   " + size);
	        }
        });
        // $('.listboxS').filter(function() {
        // 	var data = $(this);
        // 	console.log("data: " + data);
        // });
	}
});
	