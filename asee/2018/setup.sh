# This updates the files used by the workshop
# rsync -a python2 bone2:/tmp/
FILE=python
DIR=/var/lib/cloud9/examples/robot
rsync -av  --delete --no-times --no-group --no-owner $FILE bone2:$DIR/
ssh bone2 "

cd $DIR
# chgrp cloud9ide $FILE

"
