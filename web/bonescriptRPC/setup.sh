# The jQuery files in /usr/share/bone101/static are old and have a bug with sliders.
# This links  the newer files from exercises/realtime/js to /usr/share/bone101/static
# so this code can use them.

webRoot=/usr/share/bone101
here=$PWD
jq=$here/../../realtime/js

cd $webRoot
ln -s $here .

cd static
mv jquery-ui.min.js jquery-ui.min.js.orig
mv jquery-ui.css jquery-ui.css.orig
ln -s $jq/jquery-ui.css $jq/jquery-ui.min.js .
