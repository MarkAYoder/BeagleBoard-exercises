// Node.js in Action p93

var http = require('http');
var http = require('http'),
    formidable = require('formidable');

var server = http.createServer(function (req, res) {
    "use strict";
    switch (req.method) {
    case 'GET':
        show(req, res);
        break;
    case 'POST':
        upload(req, res);
        break;
    }
});

server.listen(3000);

function show(req, res) {
    "use strict";
    var html =
        '<form method="post" action="/" enctype="multipart/form-data">'
        + '<p><input type="text" name="name" /></p>'
        + '<p><input type="file" name="file" /></p>'
        + '<p><input type="submit" value="Upload" /></p>'
        + '</form>';
    res.setHeader('Content-Type', 'text/html');
    res.setHeader('Content-Length', Buffer.byteLength(html));
    res.end(html);
}

function upload(req, res) {
    "use strict";
    if (!isFormData(req)) {
        res.statusCode = 400;
        res.end('Bad Request');
        return;
    }

    var form = new formidable.IncomingForm;
    form.parse(req, function (err, fields, files) {
        console.log(fields);
        console.log(files);
        console.log(files.file);
        res.end('upload complete!');
    });

    form.on('progress', function (bytesReceived, bytesExpected) {
        var percent = Math.floor(bytesReceived / bytesExpected * 100);
        console.log(percent);
    });

}

function isFormData(req) {
    "use strict";
    var type = req.headers['content-type'] || '';
    return 0 === type.indexOf('multipart/form-data');
}

