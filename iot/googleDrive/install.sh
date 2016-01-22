# See also setup/googleDrive.txt
# http://www.howtogeek.com/196635/an-official-google-drive-for-linux-is-here-sort-of-maybe-this-is-all-well-ever-get/

# These are out of date
sudo apt-get install golang git mercurial
go get github.com/rakyll/drive

# https://github.com/odeke-em/drive/blob/master/platform_packages.md

sudo add-apt-repository ppa:twodopeshaggy/drive
sudo apt-get update
sudo apt-get install drive

drive init ~/gdrive
cd ~/gdrive
drive pull --matches NIV
drive push file
