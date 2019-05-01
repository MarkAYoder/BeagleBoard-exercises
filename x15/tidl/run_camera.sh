#!/bin/bash
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 
	exit 1
fi
cd $(dirname $0)
export DISPLAY=:0
export XAUTHORITY=/home/debian/.Xauthority
#xrandr --output HDMI1 --mode 1024x768
gedit &
GEDIT_PID=$!
./tidl_classification -g 1 -d 2 -e 2 -l ./imagenet.txt -s ./classlistMAY.txt -i 0 -c ./stream_config_j11_v2.txt 1> /tmp/tidl.log 2> /tmp/tidl-err.log &
TIDL_PID=$!
echo $TIDL_PID > /var/run/tidl-demo.pid
sleep 25
wmctrl -r "TIDL SW Stack" -e 0,550,210,-1,-1
wmctrl -r "Imagenet_EVEx2_DSPx2" -e 0,10,0,-1,-1
wmctrl -r "Classlist" -e 0,550,10,-1,-1
#wmctrl -r "Untitled Document 1 - gedit" -b add,hidden
kill $GEDIT_PID
