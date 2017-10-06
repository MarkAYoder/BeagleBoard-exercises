# Here's how to use imagemagick to display text
# Make a blank image
SIZE=320x240
TMP_FILE=/tmp/frame.png

# From: http://www.imagemagick.org/Usage/text/
# convert -background lightblue -fill blue -font Times-Roman -pointsize 24 \
#       -size $SIZE \
#       label:'ImageMagick\nExamples\nby Anthony' \
#       -draw "text 0,200 'Bottom of Display'" \
#       $TMP_FILE

# convert -size $SIZE xc:skyblue -fill white -stroke black \
#       -draw "circle 160,120 160,10
#                 line 160,120 0,0"          $TMP_FILE
                
convert -size $SIZE xc:skyblue -fill white -stroke black \
-draw "
circle 160,120 160,20
line 260,120 250,120
line 246.60254037844388,170 237.94228634059948,165
line 210,206.60254037844385 205,197.94228634059948
line 160,220 160,210
line 110.00000000000003,206.60254037844388 115.00000000000003,197.94228634059948
line 73.39745962155615,170.00000000000003 82.05771365940053,165.00000000000003
line 60,120.00000000000006 70,120.00000000000006
line 73.3974596215561,70.00000000000006 82.05771365940049,75.00000000000006
line 109.99999999999996,33.397459621556166 114.99999999999996,42.05771365940055
line 159.99999999999997,20 159.99999999999997,30
line 210,33.39745962155614 205,42.05771365940052
line 246.60254037844388,70.00000000000003 237.94228634059948,75.00000000000003
" $TMP_FILE

sudo fbi -noverbose -T 1 $TMP_FILE

# convert -list font

