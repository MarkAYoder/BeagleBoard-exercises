# Mount Bone file system on host
HOST=192.168.7.1
BONE=192.168.7.2
NAME=yoder
# sudo apt-get install sshfs
if [ "$USER" != "root" ]
then
  sudo modprobe fuse
  cd /mnt
  sudo mkdir -p BeagleBone
  sudo chown $USER:$USER BeagleBone
  chmod 777 BeagleBone
  sshfs root@$BONE:/ BeagleBone
else		# On the Bone
  cd
  mkdir -p host
  sshfs $NAME@$HOST:. host
fi

