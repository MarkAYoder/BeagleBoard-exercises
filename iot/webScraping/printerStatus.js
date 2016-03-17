#!/usr/bin/env node

// var express = require('express');
// var fs = require('fs');
var request = require('request');
var cheerio = require('cheerio');
// var app     = express();

// Let's scrape Incrediables
var url = 'http://c205-ricoh.printer.rose-hulman.edu/web/guest/en/websys/webArch/topPage.cgi';

request(url, function(error, response, html){
	if(!error){
		// console.log("html: " + html);
		var $ = cheerio.load(html);

		$('.staticProp').filter(function(){
	        var data = $(this);
	        // console.log("data: " + data);
	        // Find path to Tray 1 status
	        var path = data.children().first().children().first().children().first().children();
	        // console.log("path: " + path);
	        var tray = path.eq(0).text();
	        if(tray === "Tray 1") {
	        	var status = path.eq(3).children().first().children().first().children().first().text();
		        console.log("tray: " + tray);
		        console.log("status: " + status);
	        }
        })
	}
})
	