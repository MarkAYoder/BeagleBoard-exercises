# This sets things up for compiling
# Enable remote proc by following: http://elinux.org/EBC_Exercise_30_PRU_via_remoteproc_and_RPMsg

export PRU_CGT=/usr/share/ti/cgt-pru
export PRU_SUPPORT=/opt/source/pru-software-support-package

HEADER=P8_
PINS="27 28 29 30 39 40 41 42 43 44 45 46"

echo "-Configuring pinmux"
	for PIN_NUMBER in $PINS
	do
		config-pin -a $HEADER$PIN_NUMBER pruout
		config-pin -q $HEADER$PIN_NUMBER
	done

HEADER=P9_
PINS="25 27 28 29 30 31"	#  41 42 don't work

echo "-Configuring pinmux"
	for PIN_NUMBER in $PINS
	do
		config-pin -a $HEADER$PIN_NUMBER pruout
		config-pin -q $HEADER$PIN_NUMBER
	done
