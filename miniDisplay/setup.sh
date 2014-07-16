# From http://elinux.org/CircuitCo:MiniDisplay_Cape
echo BB-SPIDEV0 > /sys/devices/bone_capemgr.*/slots
./minidisplay-test
