#!/usr/bin/env node

var request = require('request');
var cheerio = require('cheerio');

// Get ink status on hp Printer at home
var url = 'https://hpprinter/#hId-pgInkConsumables';
// http://stackoverflow.com/questions/20433287/node-js-request-cert-has-expired#answer-29397100
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

request(url, function(err, response, html) {
	if(err) {
		console.log("err: " + err)
	} else {
		// console.log("response: " + JSON.stringify(response));
		console.log(html);
		// console.log("html: " + html);
		var $ = cheerio.load(html);

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
	