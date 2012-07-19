"use strict";

var http = require('http');

var items = [];

function show(res) {
    var html = '<h1>Todo List</h1>'
        + '<ol>'
        + items.map(function (item) {
            return '<li>' + item + '</li>';
        }).join('')
        + '</ul>'
        + '<form method="post" action="/">'
        + '<p><input type="text" name="item" /></p>'
        + '<p><input type="submit" value="Add Item" /></p>'
        + '</form>';

    res.setHeader('Content-Type', 'text/html');
    res.setHeader('Content-Length', Buffer.byteLength(html));
    res.end(html);
}

function notFound(res) {
    res.statusCode = 404;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Not Found');
}

function badRequest(res) {
    res.statusCode = 400;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Bad Request');
}

var qs = require('querystring');

function add(req, res) {
    var body = '';
    req.setEncoding('utf8');
    req.on('data', function (chunk) { body += chunk; });
    req.on('end', function () {
        var obj = qs.parse(body);
        items.push(obj.item);
        show(res);
    });
}

var server = http.createServer(function (req, res) {
    if ('/' === req.url) {
        switch (req.method) {
        case 'GET':
            show(res);
            break;
        case 'POST':
            add(req, res);
            break;
        default:
            badRequest(res);
        }
    } else {
        notFound(res);
    }
});

server.listen(3000);
