#! /bin/bash

#############################################################################
#
# Copyright (C) 2016 Zubeen Tolani <ZeekHuge - zeekhuge@gmail.com>
#
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#	* Redistributions of source code must retain the above copyright
#	  notice, this list of conditions and the following disclaimer.
#
#	* Redistributions in binary form must reproduce the above copyright
#	  notice, this list of conditions and the following disclaimer in the
#	  documentation and/or other materials provided with the
#	  distribution
#
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#############################################################################


# The script builds the pru_pin_state_reader project and configures the pinmuxing for P8_45

#Do not change until you are making required changes in the firmware code.  
HEADER=P8_
PIN_NUMBER=45
#The firmware will need significant changes to port it to PRU_CORE 2
PRU_CORE=1

echo "-Building project"
	cd PRU_PIN_STATE_READER
	# make clean
	make

echo "-Placing the firmware"
	cp gen/*.out /lib/firmware/am335x-pru$PRU_CORE-fw

echo "-Configuring pinmux"
	config-pin -a $HEADER$PIN_NUMBER pruin
	config-pin -q $HEADER$PIN_NUMBER

echo "-Rebooting"
	if [ $PRU_CORE -eq 0 ]
	then
		echo "Rebooting pru-core 0"
		echo "4a334000.pru0" > /sys/bus/platform/drivers/pru-rproc/unbind 2>/dev/null
		echo "4a334000.pru0" > /sys/bus/platform/drivers/pru-rproc/bind
	else
		echo "Rebooting pru-core 1"
		echo "4a338000.pru1"  > /sys/bus/platform/drivers/pru-rproc/unbind 2> /dev/null
		echo "4a338000.pru1" > /sys/bus/platform/drivers/pru-rproc/bind
	fi

echo "********************************************************"
echo -e "Done. Now \"echo S > /dev/rpmsg_pru31 && cat /dev/rpmsg_pru31\" and change the logical state of P8_45"
echo "********************************************************"
