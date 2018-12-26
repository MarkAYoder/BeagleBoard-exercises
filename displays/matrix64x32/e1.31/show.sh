#!/bin/bash
# Do a slide show on the LED matrix
cols=192
rows=64
while [ 1 ] ; do
	for file in show/*.jpg; do
	    echo $file
	    echo $(basename -- $file)
	    small=/tmp/$(basename -- $file)
	    gamma="${small%.*}".gamma."${small#*.}"
	    if [ ! -f $small ]; then
		echo Resizing $file
		convert $file -resize 192x64 $small
		convert $small -level 0%,100%,0.5  $gamma
	    fi
	    ./image.py $small
	    sleep 3
	    for g in 0.4 0.45 0.5 0.55 0.6 ; do
		echo gamma: $g
		convert $small -level 0%,100%,$g $gamma
	    	./image.py $gamma
	    	sleep 1
	    done
	done
done
