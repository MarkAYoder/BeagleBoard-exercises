# Instructions: https://roseshare.rose-hulman.edu/storage/u.svc/download.dn/fid/816521741589750591_13592231390549000959
VERS=PanGPLinux-5.1.1-c17.tgz
wget -O $VERS https://roseshare.rose-hulman.edu/storage/u.svc/download.dn/fid/5504766564276453800_3845984564090334472
tar -xvf $VERS
sudo apt install ./GlobalProtect_deb_arm-5.1.1.0-17.deb

globalprotect

>> connect
>> quit

ip a show gpd0
3: gpd0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1400 qdisc pfifo_fast state UNKNOWN group default qlen 500
    link/none 
    inet 137.112.193.177/32 scope global gpd0
       valid_lft forever preferred_lft forever

>> disconnect
