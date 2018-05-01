# You to disable the hdmi audo and video.
# Edit /boot/uEnv.txt and uncomment the following two lines:

#disable_uboot_overlay_video=1
#disable_uboot_overlay_audio=1

# Then reboot the bone

export PRU_CGT=/usr/share/ti/cgt-pru

here=$PWD

cd $PRU_CGT
mkdir -p bin

cd bin
ln -s `which clpru`  .
ln -s `which lnkpru` .
