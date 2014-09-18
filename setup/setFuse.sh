# Mount Bone file system on host
BONE=192.168.7.2
# sudo apt-get install sshfs
sudo modprobe fuse
cd /mnt
sudo mkdir BeagleBone
sudo chown $USER:$USER BeagleBone
chmod 777 BeagleBone
sshfs root@$BONE:/ BeagleBone
