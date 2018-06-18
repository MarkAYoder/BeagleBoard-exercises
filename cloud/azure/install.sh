npm install azure-cli -g
azure account download
azure account import [path to .publishsettings file]
# From: http://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-tutorial/#attachdisk
dmesg | grep SCSI 
sudo fdisk /dev/sdc
n
p
1


p
w
sudo mkfs -t ext4 /dev/sdc1
mkdir datadrive
sudo mount /dev/sdc1 datadrive/
# To make it automount on boot
sudo -i blkid
sudo vi /etc/fstab
UUID=840b85cb-85d6-4d1e-969f-5aa93402d9b2       /home/azureuser/datadrive
ext4    defaults        1       2

