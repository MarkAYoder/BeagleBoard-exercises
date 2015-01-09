grabber
gm composite -compose Difference grabber000.ppm  grabber019.ppm test.jpg

# Imagemagick, morphology: http://www.imagemagick.org/Usage/morphology/#intro
# Command line processing: http://www.imagemagick.org/script/command-line-processing.php
# Escapes http://www.imagemagick.org/script/escape.php
# Lots of examples: http://fmwconcepts.com/imagemagick/autotrim/index.php

convert man.gif   -morphology Erode Octagon  erode_man.gif
convert man.gif   -morphology Dilate Octagon  dilate_man.gif

convert bird.png -type TrueColor bird.jpg

convert in.png -channel red -threshold 50% out.png

identify -verbose test2.jpg

convert test.jpg -black-threshold 25% test3.jpg

