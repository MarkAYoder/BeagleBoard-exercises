# Mounts dfs files
REMOTEUSER=yoder
NAME=dfs
cd /mnt
sudo mkdir $NAME
sudo chown $USER:$USER $NAME
chmod 777 $NAME
sshfs $REMOTEUSER@dfs.rose-hulman.edu:/DFSRoot/MyDocs/$REMOTEUSER $NAME
echo "/mnt/$NAME is mounted"

