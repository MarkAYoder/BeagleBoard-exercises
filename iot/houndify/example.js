#!/usr/bin/env node
// From: https://www.houndify.com/docs/code-examples
var request = require('request');
var uuid = require('node-uuid');

var houndRequest = {
    Latitude:  43.7,
    Longitude: -79.4,
    Street: '4902 W Co Rd 750 N',
    City: 'Brazil',
    State: 'IN',
    Country: 'USA',
    ClientID: 'aJrCnINWD03mE2KKhNFr6g==',
    RequestID: 'aJrCnINWD03mE2KKhNFr6g==',
    // DeviceID: '8333687f040f3d88',
    ClientVersionCode: '1.0',
    RequestID: uuid.v1(),
    SessionID: uuid.v1(),
    TimeZone: 'America/New_York',
    TimeStamp: 123456,
    Language: 'en_US'
};

request({
    url: 'https://api.houndify.com/v1/text?query=whats the time in new york',
    headers: {
        'Hound-Request-Authentication': 'aJrCnINWD03mE2KKhNFr6g==',
        'Hound-Client-Authentication': 'aJrCnINWD03mE2KKhNFr6g==',
        'Hound-Request-Info': JSON.stringify(houndRequest)
    },
    json: true
}, function (err, resp, body) {
    //body will contain the JSON response
    console.log(body);
});