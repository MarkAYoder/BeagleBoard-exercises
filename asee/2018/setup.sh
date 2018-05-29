# This updates the files used by the workshop
FILE=python
DIR=/var/lib/cloud9/examples/robot
rsync -av  --delete --no-times --no-group --no-owner $FILE bone2:$DIR/
