# This sets things up for compiling
# Enable remote proc by following: http://elinux.org/EBC_Exercise_30_PRU_via_remoteproc_and_RPMsg

here=$PWD
export PRU_CGT=/usr/share/ti/cgt-pru
cd $PRU_CGT
mkdir bin
cd bin
ln -s `which clpru`  .
ln -s `which lnkpru` .

cd $here
cd ../..
ln -s /opt/source/pru-software-support-package/lib .
ln -s /opt/source/pru-software-support-package/include .
