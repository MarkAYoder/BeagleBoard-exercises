#!/usr/bin/env node
// From: https://github.com/andris9/Nodemailer

var nodemailer = require('nodemailer');

// create reusable transporter object using SMTP transport
var transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        user: 'Mark.A.Yoder@gmail.com',
        pass: ''
    }
});

// NB! No need to recreate the transporter object. You can use
// the same transporter object for all e-mails

// setup e-mail data with unicode symbols
var mailOptions = {
    from: 'Mark A. Yoder <Mark.A.Yoder@Rose-Hulman.edu>', // sender address
    to: 'yoder@rose-hulman.edu', // list of receivers
    subject: 'Test of nodemail 2', // Subject line
    text: 'Hello world 2', // plaintext body
    html: '<b>Hello world</b><p>Way to go!</p>' // html body
};

// send mail with defined transport object
transporter.sendMail(mailOptions, function(error, info){
    if(error){
        console.log(error);
    }else{
        console.log('Message sent: ' + info.response);
    }
});
