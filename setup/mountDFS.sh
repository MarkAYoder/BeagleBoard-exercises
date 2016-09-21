# Mounts dfs files
# sudo apt-get install sshfs
# Uncomment allow_other in /etc/fuse.conf
REMOTEUSER=yoder
NAME=/mnt/dfs
echo $USER
if [ "$USER" != "root" ]
then
    sudo mkdir -p $NAME
    sudo chown $USER:$USER $NAME
else    # On the Bone
    mkdir -p $NAME
    chown $USER:$USER $NAME
fi
chmod 777 $NAME
sshfs $REMOTEUSER@dfs.rose-hulman.edu:/DFSRoot/MyDocs/$REMOTEUSER $NAME -o allow_other
echo "$NAME is mounted"
