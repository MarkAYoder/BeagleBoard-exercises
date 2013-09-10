/* https://groups.google.com/forum/?fromgroups=#!msg/beagleboard/Ya2qE4repSY/u4lvOjF66JEJ */

var fs = require('fs');
var destroyed_key_file = '/etc/dropbear/dropbear_rsa_host_key';

fs.readFile(destroyed_key_file, function (err, data) {
  if (err) throw err;
  
  if( data===null || data.length===0 )
  {
    console.log("we have a corrupted host key file... try do delete it");
    fs.unlink(destroyed_key_file, function (err) {
    if (err) throw err;
        console.log('successfully deleted ' + destroyed_key_file);
        console.log('you should now reboot your beaglebone.');
        console.log('the /etc/init.d/dropbear script will create a new rsa host key file for you.');
        console.log('after the reboot you should be able to login over ssh');
    });
  } else {
      console.log("it seems that you have another problem, sorry");
  }
});

