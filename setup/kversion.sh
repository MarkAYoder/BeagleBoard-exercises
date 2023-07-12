#!/bin/bash
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

vm=/boot/vmlinuz-
version=$(whiptail --menu "Choose a Kernel" 25 78 16 $(ls ${vm}* | sed "s,$vm,,g" | \
    sed "s/\(.*\)/\1 ./g") 3>&1 1>&2 2>&3)

[ -z "$version" ] && echo "Canceled" && exit

echo "Updating to $version"

echo "Updating: Device Trees"
cp -v /usr/lib/linux-image-${version}/ti/k3-*.dtb /boot/firmware/ || true

rm -f /boot/firmware/Image || true
echo "Updating: /boot/firmware/Image"
cat /boot/vmlinuz-${version} | gunzip -d > /boot/firmware/Image

rm -f /boot/firmware/initrd.img || true
echo "Updating: /boot/firmware/initrd.img"
cp -v /boot/initrd.img-${version} /boot/firmware/initrd.img || true
if [ -d /usr/lib/linux-image-${version}/ti/overlays/ ] ; then
    mkdir -p /boot/firmware/overlays/ || true
    echo "Updating: overlays"
    cp /usr/lib/linux-image-${version}/ti/overlays/*.dtbo /boot/firmware/overlays/ || true
fi

echo "${version}" > /boot/firmware/kversion
echo "kversion: Updated /boot/firmware/ for: [${version}]"