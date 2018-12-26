#!/bin/bash
# Do a slide show on the LED matrix with gamma correction
# Resized images are kept in /tmp and reused

tmp=/tmp
show=show	# Where the original images are
size=192x64
gamma=0.5
time=5

while [ 1 ] ; do
	for file in $show/*.JPG; do
	    # echo $file
	    # echo $(basename -- $file)
	    small=$tmp/$(basename -- $file)
	    # Stick gamma in the file name
	    gammafile="${small%.*}".gamma."${small#*.}"
	    if [ ! -f $small ]; then
		echo Resizing $file
		convert $file -resize $size $small
		convert $small -level 0%,100%,$gamma  $gammafile
	    fi
	    # ./image.py $small
	    # sleep $time
	    ./image.py $gammafile
	    sleep $time
	done
done
