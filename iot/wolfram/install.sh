# This works without options
npm install -g wolfram

# My version will take options
git clone https://github.com/MarkAYoder/node-wolfram.git
cd $NODE_PATH
ln -s ln -s wolfram/node_modules/libxmljs/ .

# Here's another
apt-get install libxml2-dev
npm install -g wolfram-alpha
