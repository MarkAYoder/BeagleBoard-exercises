# Here's how you can run a shell command and read it's output via exec
# From http://nodejs.org/api/child_process.html#child_process_child_process_exec_command_options_callback

var exec = require('child_process').exec,
    child;

child = exec('whoami; pwd; ls -ls',
  function (error, stdout, stderr) {
    console.log('stdout: ' + stdout);
    console.log('stderr: ' + stderr);
    if (error !== null) {
      console.log('exec error: ' + error);
    }
});
