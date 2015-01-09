# Takes two input images, finds the difference, makes a mask and trims the
# second image.
gm composite -compose Difference x1.ppm x2.ppm - \
| convert ppm:- -threshold 1% \
	-morphology Erode Octagon:1 \
	-connected-components 4 -auto-level -depth 8 \
	-trim \ 
	test.ppm
display test.ppm

#	-morphology Close Diamond \
#	-morphology Thicken:-1 ConvexHull \
#	-morphology Close Diamond \
