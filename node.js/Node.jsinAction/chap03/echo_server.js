// Node.js in Action p51

var net = require('net');

var server = net.createServer(function (socket) {
    "use strict";
    console.log("socket: " + socket);
    socket.on('data', function (data) {
        socket.write(data);
    });
});

server.listen(2222);

