#!/bin/bash
# This is for installing on the eMMC on the BBB.  Use like:
# Edit below so BeagleAddr points to the IP address of the BBB.  Then:
# host$ cd ../../linux-dev/tools
# host$ ln -s ../../exercises/setup/beagle_install_kernel.sh ../../exercises/setup/remote_install_kernel.sh .
# host$ cd ..
# host$ tools/remote_install_kernel.sh
# The needed files will be copied on the BBB. Then on the BBB:
# beagle$ cd linux-dev
# beagle$ tools/beagle_install_kernal.sh
# The files will be copied to the correct places.  Reboot and enjoy.

# BeagleAddr=137.112.41.141
BeagleAddr=yoder-dell.dhcp.rose-hulman.edu
DIR=$PWD
USER=yoder

if [ -f "${DIR}/system.sh" ] ; then
	. ${DIR}/system.sh

	KERNEL_UTS=$(cat "${DIR}/KERNEL/include/generated/utsrelease.h" | awk '{print $3}' | sed 's/\"//g' )
#	location="${DIR}/deploy/disk"
	mkimage -A arm -O linux -T kernel -C none -a ${ZRELADDR} -e ${ZRELADDR} -n ${KERNEL_UTS} -d "${DIR}/deploy/${KERNEL_UTS}.zImage" "deploy/uImage-${KERNEL_UTS}"

else
	echo "Missing system.sh, please copy system.sh.sample to system.sh and edit as needed"
	echo "cp system.sh.sample system.sh"
	echo "gedit system.sh"
	exit 1
fi

ssh $USER@$BeagleAddr mkdir -p linux-dev/KERNEL/include/generated linux-dev/tools
scp ${DIR}/KERNEL/include/generated/utsrelease.h $USER@$BeagleAddr:linux-dev/KERNEL/include/generated/utsrelease.h
scp tools/beagle_install_kernel.sh $USER@$BeagleAddr:linux-dev/tools
scp -r version.sh system.sh deploy $USER@$BeagleAddr:linux-dev

