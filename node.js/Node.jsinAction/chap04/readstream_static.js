var http = require('http')
  , parse = require('url').parse
  , join = require('path').join
  , fs = require('fs');

var root = __dirname;

var server = http.createServer(function(req, res){
  var url = parse(req.url);
  var path = join(root, url.pathname);
  var stream = fs.createReadStream(path);
  stream.pipe(res);
});

server.listen(3000);
