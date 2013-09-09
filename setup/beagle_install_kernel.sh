#!/bin/sh -e
# Modified by Mark A. Yoder for installing on eMMC
# First run remote_install_kernel.sh on the host.  It will copy this and other
# needed files to the BBB.  Then run this file on the BBB to install.
# 
# Copyright (c) 2009-2013 Robert Nelson <robertcnelson@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

unset KERNEL_UTS
unset ZRELADDR

DIR=$PWD

. ${DIR}/version.sh

mmc_write_rootfs () {
	echo "Installing ${KERNEL_UTS}-modules.tar.gz"

	if [ -d "${location}/lib/modules/${KERNEL_UTS}" ] ; then
		rm -rf "${location}/lib/modules/${KERNEL_UTS}" || true
	fi

	tar ${UNTAR} "${DIR}/deploy/${KERNEL_UTS}-modules.tar.gz" -C "${location}"
	sync

	echo "Installing ${KERNEL_UTS}-firmware.tar.gz"

	if [ -d "${DIR}/deploy/tmp" ] ; then
		rm -rf "${DIR}/deploy/tmp" || true
	fi
	mkdir -p "${DIR}/deploy/tmp/"

	tar -xf "${DIR}/deploy/${KERNEL_UTS}-firmware.tar.gz" -C "${DIR}/deploy/tmp/"
	sync

	cp -v "${DIR}/deploy/tmp"/*.dtbo "${location}/lib/firmware/" 2>/dev/null || true
	sync

	rm -rf "${DIR}/deploy/tmp/" || true

	if [ "${ZRELADDR}" ] ; then
		if [ ! -f "${location}/boot/SOC.sh" ] ; then
			if [ -f "${location}/boot/uImage" ] ; then
			#Possibly Angstrom: dump a newer uImage if one exists..
				if [ -f "${location}/boot/uImage_bak" ] ; then
					rm -f "${location}/boot/uImage_bak" || true
				fi

				mv "${location}/boot/uImage" "${location}/boot/uImage_bak"
				cp ${DIR}/deploy/uImage-${KERNEL_UTS} /boot
				cd /boot
				ln -s uImage-${KERNEL_UTS} uImage
			fi
		fi
	fi
}

if [ -f "${DIR}/system.sh" ] ; then
	. ${DIR}/system.sh

	KERNEL_UTS=$(cat "${DIR}/KERNEL/include/generated/utsrelease.h" | awk '{print $3}' | sed 's/\"//g' )

# This will make the root filesystem appear at linux-dev/deploy/disk
	if [ ! -e ${DIR}/deploy/disk ]; then
		ln -s /   ${DIR}/deploy/disk
	fi
	location="${DIR}/deploy/disk"
	UNTAR="xf"
	mmc_write_rootfs

else
	echo "Missing system.sh, please copy system.sh.sample to system.sh and edit as needed"
	echo "cp system.sh.sample system.sh"
	echo "gedit system.sh"
fi

