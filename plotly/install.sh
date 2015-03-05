# This uses the free BASIC version of plotlyjs which runs locally.
# From https://plot.ly/javascript/
wget http://d14fo0winaifog.cloudfront.net/plotlyjs_basic.zip
unzip plotlyjs_basic.

ln -s plotly_20150812a_basic weather    # Make path easier to remember

# Link it where the browser can see it 
here=$PWD
cd /var/lib/cloud9
ln -s $here .