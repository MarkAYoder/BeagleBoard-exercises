# Send image to Google Vision to find the text in it.
# Takes the returned json file and marks a box around the located text.
# Usage:  pic.sh image.jpg

FRAME=$1
JSON=/tmp/frame.json
TMP=$1

# echo Resizing
# # 1280x720, 640x360, 320x176
# convert $FRAME -resize 320x180 $TMP

# echo Converting to gray
# convert $FRAME -colorspace Gray $FRAME

echo "Sending to Google"
if ./getText.js $TMP > $JSON
then echo Success
else echo Failure; exit 1
fi

# echo "Marking boxes"
./boxText.js $TMP $JSON

# Append 4 images into one
# convert \( frame0.jpg frame90.jpg +append \) \
#     \( frame180.jpg frame270.jpg +append \) -append tmp.jpg
