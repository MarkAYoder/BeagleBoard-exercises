# Get freeboard
git clone https://github.com/Freeboard/freeboard.git

# Copy Brazil weather dashboard
cp brazil.js freeboard

# Make it so the web server can see it

here=$PWD/freeboard
cd /var/lib/cloud9
ln - $here .
