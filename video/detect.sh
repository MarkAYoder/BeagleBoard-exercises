#!/bin/bash
# Takes two input images, finds the difference, makes a mask and trims the
# second image.
REF=ref.ppm
OBJ=obj.ppm
OUT=out.ppm
DIF=dif.ppm
GRAB=grabber000.ppm
# ./grabber
# mv $GRAB $REF
# read -p "Press [Enter] key to grab next image ..."
# ./grabber
# mv $GRAB $OBJ
composite -compose Difference $REF $OBJ $DIF
convert $DIF \
    -auto-level \
    -threshold 1% \
	-morphology Erode Octagon:1 \
	$OUT
display $OUT

#	-morphology Close Diamond \
#	-morphology Thicken:-1 ConvexHull \
#	-morphology Close Diamond \
#	-connected-components 4 -auto-level -depth 8 \
#   	-trim \

convert obj.ppm  thresh.ppm \
          -alpha off -compose CopyOpacity -composite \
          both.ppm