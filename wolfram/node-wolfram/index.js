var xml = require('libxmljs'),
    request = require('request')

var Client = exports.Client = function Client(appKey) {
  this.appKey = appKey
}

Client.prototype.query = function(input, cb) {
  if(!this.appKey) {
    return cb("Application key not set", null)
  }
  var options;
  var search;
  if(typeof(input) === 'object') {
    // If an ojbect is passed, look for search string and options
    search  = input.search;
    options = input.options;
  } else {
    // If it's not an object, assume it's the search string
    search = input;
    options = "";
  }

  var uri = 'http://api.wolframalpha.com/v2/query?input=' + encodeURIComponent(search) + '&primary=true&appid=' + this.appKey + options;

  request(uri, function(error, response, body) {
    if(!error && response.statusCode == 200) {
      var doc = xml.parseXml(body), root = doc.root()

      if(root.attr('error').value() != 'false') {
        var message = root.get('//error/msg').text()
        return cb(message, null)
      } else {
        var pods = root.find('pod').map(function(pod) {
       	  var title = pod.attr('title').value();
          var subpods = pod.find('subpod').map(function(node) {
            return {
              title: node.attr('title').value(),
              value: node.get('plaintext').text(),
              image: node.get('img').attr('src').value()
            }
          })
          var primary = (pod.attr('primary') && pod.attr('primary').value()) == 'true'
          return { title : title, subpods: subpods, primary: primary }
        })
       return cb(null, pods)
      }
    } else {
      return cb(error, null)
    }
  })
}

exports.createClient = function(appKey) {
  return new Client(appKey)
}
