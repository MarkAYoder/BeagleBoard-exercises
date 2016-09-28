# Used to format and mount a disk
DISK=kernel
DIR=~/gpd
sudo mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/google-$DISK
mkdir -p $DIR
sudo mount -o discard,defaults /dev/disk/by-id/google-$DISK $DIR
sudo chown mark_a_yoder:mark_a_yoder $DIR
