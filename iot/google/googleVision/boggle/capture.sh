# From exploringBB/chp12/fswebcam
FRAME=/tmp/frame.jpg
JSON=/tmp/frame.json

fswebcam --device /dev/video0 --input 0 --resolution 320x176 \
    --no-banner \
    --jpeg 100 --save $FRAME

# echo Resizing
# convert $FRAME -resize 320x180 $FRAME

# echo Converting to gray
# convert $FRAME -colorspace Gray $FRAME

echo "Sending to Google"
./boggle.js $FRAME > $JSON

# echo "Marking boxes"
./boxText.js $FRAME $JSON

# Append 4 images into one
# convert \( frame0.jpg frame90.jpg +append \) \
#     \( frame180.jpg frame270.jpg +append \) -append tmp.jpg
