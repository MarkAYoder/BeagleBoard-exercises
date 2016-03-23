#!/usr/bin/env node
// Reads Sue's color printer

var request = require('request');
var cheerio = require('cheerio');

// Let's scrape c207
var url = ' http://c207.printer.rose-hulman.edu/hp/device/this.LCDispatcher';
// http://stackoverflow.com/questions/20433287/node-js-request-cert-has-expired#answer-29397100
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
var tray;
var status;
var size;

request(url, function(err, response, html){
	if(err) {
		console.log("err: " + err);
	} else {
		// console.log("html: " + html);
		var $ = cheerio.load(html);

		$('#Text19').filter(function(){
	        tray = $(this).text();
        });
		$('#Text20').filter(function(){
	        status = $(this).text();
        });
		$('#Text22').filter(function(){
	        size = $(this).text();
        });
		console.log("tray:   " + tray);
        console.log("status: " + status);
        console.log("size:   " + size);
	}
});
	