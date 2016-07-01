# Get reference manuals
# From Exploring BeagleBone Black
# AM335x PRU-ICSS Reference Guide
wget https://github.com/beagleboard/am335x_pru_package/raw/master/am335xPruReferenceGuide.pdf

# TI PRU Wiki:  tiny.cc/ebb1308
# PRU Linux Application Loader API Guide:   tiny.cc/ebb1309
# PRU Debugger User Guide:  tiny.cc/ebb1310

# From http://exploringbeaglebone.com/chapter13
wget http://exploringbeaglebone.com/wp-content/uploads/2014/12/Instruction-Set-Sheet.pdf

# uio_pruss.c  Used to set RAM buffer size
wget http://lxr.free-electrons.com/source/drivers/uio/uio_pruss.c

# PRU C compiler: tiny.cc/ebb1311


# remoteproc
# http://processors.wiki.ti.com/index.php/PRU-ICSS

# Examples
# http://theembeddedkitchen.net/categories/beaglelogic

# Get latest kernel
apt-get install linux-image-4.4.14-ti-r33
apt-get install linux-headers-4.4.14-ti-r33

# Get BeagleLogic
git clone https://github.com/abhishek-kakkar/BeagleLogic.git
cd BeagleLogic/beaglelogic-firmware
make
make devicetree
make firmware

# This may be a better lead. Works with 4.4.11-ti-r29
https://zeekhuge.github.io/
https://zeekhuge.github.io/post/a_handfull_of_commands_and_scripts_to_get_started_with_beagleboneblack/#working_with_prus:01d25bfd2399ec47b9c04f156786eab8

git clone https://github.com/ZeekHuge/BeagleScope.git

# Then add
export PRU_CGT=/usr/share/ti/cgt-pru
cd $PRU_CGT
mkdir bin
cd bin
ln -s `which clpru`  .
ln -s `which lnkpru` .

cd BeagleScope/examples/firmware_exmples/pru_blinky
./deploy
# Wire and LED to P8_45 and it should be blinking.
# You might have to disable HDMI for this to work.

# Now on to the Labs at: http://processors.wiki.ti.com/index.php/PRU_Training:_Hands-on_Labs
git clone git://git.ti.com/pru-software-support-package/pru-software-support-package.git

cd pru-software-support-package/labs

