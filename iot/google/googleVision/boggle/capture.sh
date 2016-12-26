# From exploringBB/chp12/fswebcam
fswebcam --device /dev/video0 --input 0 --resolution 1280x720 \
    --jpeg 100 --save /tmp/frame.jpg

convert /tmp/frame.jpg -crop 1280x700+0+0 frame.jpg
