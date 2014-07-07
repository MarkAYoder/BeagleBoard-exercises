# Update git soe it can use gnome-keyring
# apt-get install git-man/wheezy-backports
# apt-get install git/wheezy-backports

# apt-get install libgnome-keyring-dev

KEYPATH=/usr/share/doc/git/contrib/credential/gnome-keyring
cd $KEYPATH
make
git config --global $KEYPATH/git-credential-gnome-keyring