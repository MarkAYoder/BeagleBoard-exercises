# Sets up files so my_balance is built in the Robotics_Cape_Installer structure
HERE=$PWD
BALDIR=my_balance

cd /opt/source/Robotics_Cape_Installer/examples
mkdir -p $BALDIR
cd $BALDIR
ln -s $HERE/* .
