// From page 67 of Node.js in action.

var flow = require('nimble'),
    exec = require('child_process').exec;

function downloadNodeVersion(version, destination, callback) { //Download Node source code for a given version
    "use strict";
    var url = 'http://nodejs.org/dist/node-v' + version + '.tar.gz',
        filepath = destination + '/' + version + '.tgz';
    exec('wget ' + url + ' -O ' + filepath, callback);
}

flow.series([	// Execute a series of tasks in sequence
    function (callback) {
        "use strict";
        flow.parallel([		// Execute downloads in parallel
            function (callback) {
                console.log('Downloading Node v0.4.6...');
                downloadNodeVersion('0.4.6', '/tmp', callback);
            },
            function (callback) {
                console.log('Downloading Node v0.4.7...');
                downloadNodeVersion('0.4.7', '/tmp', callback);
            }
        ], callback);  // What's this callback do?
    },
    function (callback) {
        "use strict";
        console.log('Creating archive of downloaded files...');
        exec(		// Create archive flile
            'tar cvf node_distros.tar /tmp/0.4.6.tgz /tmp/0.4.7.tgz',
            function (error, stdout, stderr) {
                console.log('All done!');
                callback();
            }
        );
    }
]);

