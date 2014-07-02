#!/usr/bin/env node

var express = require('express');
var fs = require('fs');
var request = require('request');
var cheerio = require('cheerio');
var app     = express();
var colors  = require('colors');

var	url = 'http://www.heavens-above.com/AmateurSats.aspx?lat=39.4992&lng=-87.1979&loc=Brazil&alt=189&tz=EST';
var htmlFile = 'output2.html';	

    // The structure of our request call
    // The first parameter is our URL
    // The callback function takes 3 parameters, an error, response status code and the html

//	request(url, function(err, response, html){
	fs.readFile(htmlFile, function(err, html){
	    console.log(htmlFile + ': read');

        // fs.writeFile(htmlFile, html, function(err) {
        //     console.log("html file written");
        // });
        // First we'll check to make sure no errors occurred when making the request

        if(!err){
            // Next, we'll utilize the cheerio library on the returned html which will essentially give us jQuery functionality

            var $ = cheerio.load(html);
        
            
            // fs.writeFile('output.json', JSON.stringify($), function(err) {
            //     console.log("json file written");
            // });


            // Finally, we'll define the variables we're going to capture

			var json = { name: "", date: "", start: ""};
			
			$('.lightrow', '.standardTable').filter(function(){
    	        var data = $(this);
    	        
    	        // console.log('data = '.red + data);
    	        
    	        // console.log('length = '.green + data.find('td').length);
    	        // console.log('a = '.blue + data.find('a'));
    	        json.name =  data.find('a').html().split(/<>/)[0];
    	        var date =  data.html().split('<td');
    	        console.log('a split = '.blue + JSON.stringify(json));
                console.log('date = '.red + date);
                for (var property in date) {
                  console.log(property + ': ' + date[property]+'; ');
                }
            });
			
			// console.log($);
		}
	});
