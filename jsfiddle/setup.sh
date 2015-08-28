# The jQuery files in /var/lib/cloud9/static are old and have a big with sliders.
# This links  the newer files from exercises/realtime to /var/lib/cloud9/static2
# so this code can use them.

c9=/var/lib/cloud9
jq=`pwd`/../realtime/js
mkdir -p $c9/static2
cd $c9/static2
ln -s $jq/jquery-ui.css $jq/jquery-ui.min.js $jq/jquery.min.js .
ln -s ../static/images .