#!/usr/bin/env node

const HolidayAPI = require('node-holidayapi');
const util = require('util');
const hapi = new HolidayAPI('ee09d3cc-fc01-4e5a-9a57-759cb16fa78a').v1;
const date = new Date();
const exec = require('child_process').exec;
var parameters = {
  // Required
  country: 'US',
  year:    2017,
  // Optional
  month:    date.getMonth()+1,
  day:      date.getDate(),
  // previous: true,
  // upcoming: true,
  // public:   true,
  // pretty:   true,
};

hapi.holidays(parameters, function (err, data) {
    if(err) {
        console.log("err: " + err);
    }
    console.log("data: " + data);
    console.log("data: " + data.holidays[0].name);
  
    console.log("date: " + date.getDate());
  
    exec("the_matrix_scrolltext " + data.holidays[0].name, (error, stdout, stderr) => {
    if (error) {
      console.error(`exec error: ${error}`);
      return;
    }
    console.log(`stdout: ${stdout}`);
    console.log(`stderr: ${stderr}`);
    });
});