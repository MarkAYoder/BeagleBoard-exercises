# Mounts dfs files
REMOTEUSER=yoder
NAME=/mnt/dfs
sudo mkdir -p $NAME
sudo chown $USER:$USER $NAME
chmod 777 $NAME
sshfs $REMOTEUSER@dfs.rose-hulman.edu:/DFSRoot/MyDocs/$REMOTEUSER $NAME
echo "$NAME is mounted"
