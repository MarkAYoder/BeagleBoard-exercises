var net = require('net');
var server = net.createServer(function (client) {
    "use strict";
    client.end('hello net world\r\n');
});

server.listen(8000, '127.0.0.1');

