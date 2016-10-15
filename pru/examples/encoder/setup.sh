export PRU_CGT=/usr/share/ti/cgt-pru
export PRU_SUPPORT=/opt/source/pru-software-support-package

here=$PWD

cd $PRU_CGT
mkdir -p bin
cd bin
ln -s `which clpru`  .
ln -s `which lnkpru` .

cd $here

HEADER=P8_
PINS="15 16"

echo "-Configuring pinmux"
	for PIN_NUMBER in $PINS
	do
		config-pin -a $HEADER$PIN_NUMBER pruin
		config-pin -q $HEADER$PIN_NUMBER
	done
