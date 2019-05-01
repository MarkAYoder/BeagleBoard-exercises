# From: https://github.com/rcn-ee/tidl-api/tree/v01.02.02-bb.org
#   Check for latest branch
# See also: http://downloads.ti.com/mctools/esd/docs/tidl-api/index.html
# and ... http://software-dl.ti.com/processor-sdk-linux/esd/docs/latest/linux/Foundational_Components_TIDL.html
# and training http://software-dl.ti.com/processor-sdk-linux/esd/docs/latest/linux/Foundational_Components_TIDL.html#training

# This appears to be all preinstalled on the BeagleBone AI
# To autostart, 
HERE=$PWD
mkdir -p ~/.config/autostart
cd ~/.config/autostart
ln -s $HERE/tidl.desktop .
cd $HERE

# Run sudo visudo and add the following line at the end so su password isn't needed
debian ALL=(ALL) NOPASSWD: /home/debian/tidl-api/examples/classification/run_camera.sh

# Put in our run_camera.sh
cd ~/tidl-api/examples/classification
mv run_camera.sh run_camera.sh.orig
ln -s $HERE/run_camera.sh .
ln -s $HERE/classlistMAY.txt .

# The rest of this appears to be already installed.

sudo apt update
sudo apt install ti-opencl libboost-dev libopencv-core-dev libopencv-imgproc-dev libopencv-highgui-dev libjson-c-dev

# Most were already installed and up to date.  Install time 38s

# utils
git clone git://git.ti.com/tidl/tidl-utils.git

git clone https://github.com/rcn-ee/tidl-api    # 15s
cd tidl-api/
git checkout origin/v01.02.02-bb.org -b v01.02.02-bb.org
make -j2 build-api      # 1m31s

sudo mkdir -p /usr/share/ti/tidl
sudo chown -R 1000:1000 /usr/share/ti/tidl/

make -j2 build-examples # 2m28s

# Extras
# sudo apt-get install libjsoncpp-dev   # May not be needed
sudo apt install libjson-c-dev

# If you get a cmemk error:
cd /opt/scripts/tools/ ; git pull ; sudo ./update_kernel.sh ; sudo apt upgrade

# Fix a path error with
cd /usr/share/ti/tidl
sudo ln -s ~/exercises/x15/tidl/tidl-api/examples/ .

# Check the temp with
cat /sys/class/thermal/*/temp

# Check current cpu speed
cat /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_cur_freq

# Gtk-Message: Failed to load module "canberra-gtk-module"
sudo apt install libcanberra-gtk-module libcanberra-gtk3-module

# Image viewer "eye of gnome"
sudo apt install eog

# Need for Network Viewer
sudo apt install graphviz
