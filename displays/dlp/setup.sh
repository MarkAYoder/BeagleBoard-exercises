# From: http://www.ti.com/lit/ug/dlpu049c/dlpu049c.pdf
i2cset -y 2 0x1b 0x0b 0x00 0x00 0x00 0x00 i
i2cset -y 2 0x1b 0x0c 0x00 0x00 0x00 0x1b i

sudo fbi -noverbose -T 1 -a boris.png

mplayer -vo drm RedsNightmare.mpg 

apt install youtube-dl
youtube-dl https://www.youtube.com/watch?v=RWq-BPkbQEE -o tmp.mp4
ffmpeg -i tmp.mp4 -vf scale=320:-1 blues.mp4 
mplayer-vo drm blues.mp4
