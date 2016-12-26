# From exploringBB/chp12/fswebcam
FRAME=/tmp/frame.jpg
JSON=/tmp/frame.json

fswebcam --device /dev/video0 --input 0 --resolution 1280x720 \
    --no-banner \
    --jpeg 100 --save $FRAME

echo "Sending to Google"
./boggle.js $FRAME > $JSON

# echo "Marking boxes"
./boxText.js $FRAME $JSON
