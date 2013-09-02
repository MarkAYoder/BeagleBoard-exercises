#!/bin/bash
# This is for installing on the eMMC on the BBB
# The needed files are first copied on the BBB, the then install_kernal.sh
# script is used.

DIR=$PWD
BeagleAddr=137.112.41.116

# KERNEL_UTS=$(cat "${DIR}/KERNEL/include/generated/utsrelease.h" | awk '{print $3}' | sed 's/\"//g' )

# ssh root@$BeagleAddr mkdir -p linux-dev/KERNEL/include/generated linux-dev/tools
# scp ${DIR}/KERNEL/include/generated/utsrelease.h root@$BeagleAddr:linux-dev/KERNEL/include/generated/utsrelease.h
scp tools/my_install_kernel.sh root@$BeagleAddr:linux-dev/tools
# scp -r deploy root@$BeagleAddr:linux-dev
# scp version.sh system.sh root@$BeagleAddr:linux-dev

# ssh root@$BeagleAddr ln -s / linux-dev/deploy/disk

if [ -f "${DIR}/system.sh" ] ; then
	. ${DIR}/system.sh

	KERNEL_UTS=$(cat "${DIR}/KERNEL/include/generated/utsrelease.h" | awk '{print $3}' | sed 's/\"//g' )
	location="${DIR}/deploy/disk"
#	mkimage -A arm -O linux -T kernel -C none -a ${ZRELADDR} -e ${ZRELADDR} -n ${KERNEL_UTS} -d "${DIR}/deploy/${KERNEL_UTS}.zImage" "deploy/uImage-${KERNEL_UTS}"

else
	echo "Missing system.sh, please copy system.sh.sample to system.sh and edit as needed"
	echo "cp system.sh.sample system.sh"
	echo "gedit system.sh"
fi

