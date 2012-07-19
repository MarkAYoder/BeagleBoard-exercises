var http = require('http');
var i = 0;

http.createServer(function (req, res) {
    "use strict";
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('hello world ' + i + '\n');
    i += 1;
}).listen(8000, "127.0.0.1");

