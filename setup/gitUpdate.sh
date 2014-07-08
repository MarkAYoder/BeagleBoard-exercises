# Update git so it can use gnome-keyring
DIST=jessie
# DIST=wheezy
apt-get install git-man/$DIST git/$DIST libgnome-keyring-dev

KEYPATH=/usr/share/doc/git/contrib/credential/gnome-keyring
cd $KEYPATH
make
rm git-credential-gnome-keyring.o
git config --global credential.helper $KEYPATH/git-credential-gnome-keyring