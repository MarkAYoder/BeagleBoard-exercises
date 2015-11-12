# TARGET=think
TARGET=host
cd ..
rsync -e ssh -avz --links --delete studentWork yoder@$TARGET:BeagleBoard > /tmp/mysync &
tail -f /tmp/mysync

