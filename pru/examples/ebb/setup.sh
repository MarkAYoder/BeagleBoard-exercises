export PRU_CGT=/usr/share/ti/cgt-pru
cd $PRU_CGT
mkdir bin
cd bin
ln -s `which clpru`  .
ln -s `which lnkpru` .

config-pin -a P9_27 pruout
config-pin -a P9_28 pruin
