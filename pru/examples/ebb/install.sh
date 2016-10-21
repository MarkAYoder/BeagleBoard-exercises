export PRU_CGT=/usr/share/ti/cgt-pru

here=$PWD

cd $PRU_CGT
mkdir -p bin

cd bin
ln -s `which clpru`  .
ln -s `which lnkpru` .
