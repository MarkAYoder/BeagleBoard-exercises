git clone https://github.com/mcdeoliveira/Robotics_Cape_Installer.git
git clone https://github.com/mcdeoliveira/rcpy


sudo apt update
sudo apt install python3 python3-setuptools python3-dev

cd Robotics_Cape_Installer
git checkout devel
sudo ./install.sh

cd ../rcpy
git checkout devel
sudo python3 setup.py install
