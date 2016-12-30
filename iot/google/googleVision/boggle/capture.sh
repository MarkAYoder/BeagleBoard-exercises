# From exploringBB/chp12/fswebcam
FRAME=/tmp/frame.jpg
JSON=/tmp/frame.json

fswebcam --device /dev/video0 --input 0 --resolution 640x360 \
    --rotate 270 \
    --no-banner \
    --jpeg 100 --save $FRAME

# echo Resizing
# 1280x720, 640x360, 320x176
# convert $FRAME -resize 320x180 $FRAME

# echo Converting to gray
# convert $FRAME -colorspace Gray $FRAME

echo "Sending to Google"
if ./boggle.js $FRAME > $JSON
then echo Success
else echo Failure; exit 1
fi

# echo "Marking boxes"
./boxText.js $FRAME $JSON

# Append 4 images into one
# convert \( frame0.jpg frame90.jpg +append \) \
#     \( frame180.jpg frame270.jpg +append \) -append tmp.jpg
