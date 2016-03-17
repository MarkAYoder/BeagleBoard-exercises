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

		var title, release, rating;
		var json = { title : "", release : "", rating : ""};

		$('.staticProp').filter(function(){
	        var data = $(this);
	        console.log("data: " + data);
	        var path = data.children().first().children().first().children().first().children();
	        var tray = path.eq(0).text();
	        var status = path.eq(3).children().first().children().first().children().first().text();
	        title = data.children().first();
	        release = data.children().last().children().text();

	        json.title = title;
	        json.release = release;
	        console.log("path: " + path);
	        console.log("tray: " + tray);
	        console.log("status: " + status);
	        console.log("title: " + title);
        })
	}

	console.log(json);

})
	