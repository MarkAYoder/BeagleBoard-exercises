#!/bin/bash
# Do a slide show on the LED matrix
cols=192
rows=64
while [ 1 ] ; do
	for file in show/*.jpg; do
	    echo $file
	    echo $(basename -- $file)
	    small=/tmp/$(basename -- $file)
	    if [ ! -f $small ]; then
		convert $file -resize 192x64 $small
	    fi
	    ./image.py $small
	    sleep 10
	done
done
