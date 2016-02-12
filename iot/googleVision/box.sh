#!/bin/bash
convert $1 -fill none -stroke black -strokewidth 3 \
	-draw "polygon 197,243 745,243 745,535 197,535" \
	tmp.jpg
display tmp.jpg &
