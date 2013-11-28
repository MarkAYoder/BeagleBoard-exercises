#!/bin/bash
# Loads files needed to run boneServer.js

# npm install -g socket.io
# npm install -g bonescript

wget http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js
wget http://jqueryui.com/resources/download/jquery-ui-1.10.4.zip
wget http://www.flotcharts.org/downloads/flot-0.8.2.zip
# https://github.com/mrdoob/three.js/tree/master/build
# http://www.github.com/DiogenesTheCynic/FullScreenMario
# wget https://github.com/Diogenesthecynic/FullScreenMario/archive/master.zip
# unzip master.zip
# mv FullScreenMario-master/ FullScreenMario

# http://fortawesome.github.io/Font-Awesome/

# http://subtlepatterns.com/

unzip jquery-ui-1.10.4.zip
mv jquery-ui-1.10.4/ui/minified/jquery-ui.min.js .
mv jquery-ui-1.10.4/themes/base/jquery-ui.css .
rm -r jquery-ui-1.10.4.zip jquery-ui-1.10.4

unzip flot-0.8.2.zip 
mv flot/jquery.flot.js .
rm -r flot-0.8.2.zip flot
