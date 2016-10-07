# This uses the free BASIC version of plotlyjs which runs locally.
# From https://plot.ly/javascript/
mkdir js && cd js
wget https://cdn.plot.ly/plotly-latest.min.js

# Load these to serve them locally
wget https://code.jquery.com/jquery-2.2.4.min.js
mv jquery-2.2.4.min.js jquery.min.js
wget http://underscorejs.org/underscore-min.js

cd ..

# Link it where the browser can see it 
here=$PWD
cd /usr/share/bone101
# ln -s $here .
cd $here
