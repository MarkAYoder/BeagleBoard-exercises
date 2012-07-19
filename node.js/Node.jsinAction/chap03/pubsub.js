// Node.js in Action p53

var events = require('events'),
    net = require('net');

var channel = new events.EventEmitter();
channel.clients = {};
channel.subscriptions = {};
channel.setMaxListeners(50);

channel.on('join', function (id, client) {
    "use strict";
    var welcome = "Welcome!\n"
        + 'Guests online: ' + this.listeners('broadcast').length;
    client.write(welcome + "\n");

    this.clients[id] = client;
    this.subscriptions[id] = function (senderId, message) {
        if (id !== senderId) {
            this.clients[id].write(message);
        }
    };
    this.on('broadcast', this.subscriptions[id]);
    channel.emit('broadcast', id, id + " has joined the chat.\n");
});

channel.on('leave', function (id) {
    "use strict";
    channel.removeListener('broadcast', this.subscriptions[id]);
    channel.emit('broadcast', id, id + " has left the chat.\n");
});

channel.on('shutdown', function () {
    "use strict";
    channel.emit('broadcast', '', "Chat has shut down.\n");
    channel.removeAllListeners('broadcast');
});

var server = net.createServer(function (client) {
    "use strict";
    var id = client.remoteAddress + ':' + client.remotePort;
    client.on('connect', function () {
        console.log('connect');
        channel.emit('join', id, client);
    });
    client.on('data', function (data) {
        console.log('data: ' + data);
        data = data.toString();
        channel.emit('broadcast', id, data);
    });
    client.on('close', function () {
        console.log('close');
        channel.emit('leave', id);
    });
});
server.listen(2222);

