# From http://elinux.org/CircuitCo:MiniDisplay_Cape
echo -10 > /sys/devices/bone_capemgr.*/slots
echo BB-SPIDEV0 > /sys/devices/bone_capemgr.*/slots
./minidisplay-test
