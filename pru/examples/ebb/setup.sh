export PRU_CGT=/usr/share/ti/cgt-pru
export PRU_SUPPORT=/opt/source/pru-software-support-package

here=$PWD

cd $PRU_CGT
mkdir -p bin
cd bin
ln -s `which clpru`  .
ln -s `which lnkpru` .

cd $here

config-pin -a P9_27 pruout
config-pin -a P9_28 pruin
