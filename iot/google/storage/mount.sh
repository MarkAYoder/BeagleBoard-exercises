# Used to mount a disk
DISK=kernel
DIR=~/gpd
mkdir -p $DIR
sudo mount -o discard,defaults /dev/disk/by-id/google-$DISK $DIR
sudo chown mark_a_yoder:mark_a_yoder $DIR
