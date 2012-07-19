//From page 62 of Node.js in Action

var path = require('path'),
    fs = require('fs'),
    request = require('request'),
    htmlparser = require('htmlparser');

function next(err, result) {
    "use strict";
    if (err) {throw new Error(err); }

    var currentTask = tasks.shift();

    if (currentTask) {
        currentTask(result);
    }
}

var tasks = [
    function () {
        "use strict";
        var configFilename = './rss_feeds.txt';
        path.exists(configFilename, function (exists) {
            if (!exists) {
                next('Create a list of RSS feeds in the file ./rss_feeds.txt.');
            } else {
                next(false, configFilename);
            }
        });
    },
    function (configFilename) {
        "use strict";
        fs.readFile(configFilename, function (err, feedList) {
            if (err) {
                next(err.message);
            } else {
                feedList = feedList
                    .toString()
                    .replace(/^\s+|\s+$/g, '')
                    .split("\n");
                var random = Math.floor(Math.random() * feedList.length);
                console.log('Feed: ' + random);
                next(false, feedList[random]);
            }
        });
    },
    function (feedUrl) {
        "use strict";
        request({uri: feedUrl}, function (err, response, body) {
            if (err) {
                next(err.message);
            } else if (response.statusCode === 200) {
                next(false, body);
            } else {
                next('Abnormal request status code.');
            }
        });
    },
    function (rss) {
        "use strict";
        var handler = new htmlparser.RssHandler(),
            parser = new htmlparser.Parser(handler),
            item;
        parser.parseComplete(rss);

        if (handler.dom.items.length) {
            item = handler.dom.items.shift();
            console.log(item.title);
            console.log(item.link);
        } else {
            next('No RSS items found.');
        }
    }
];

next();
