#!/bin/bash
# Find where the eQEP .dtbo files are
ls /lib/firmware/ | grep -i qep
# PyBBIO-eqep0-00A0.dtbo
# PyBBIO-eqep1-00A0.dtbo
# PyBBIO-eqep2-00A0.dtbo
# PyBBIO-eqep2b-00A0.dtbo

# Get Derek Molloy's P8 and P9 header tables
wget https://github.com/derekmolloy/boneDeviceTree/raw/master/docs/BeagleboneBlackP8HeaderTable.pdf
wget https://github.com/derekmolloy/boneDeviceTree/raw/master/docs/BeagleboneBlackP9HeaderTable.pdf
# Search for eqp
# eQEP2 looks like a good one, but it appears in two place.  Try the first one
export SLOTS=/sys/devices/bone_capemgr.*/slots
echo PyBBIO-eqep2 > $SLOTS
-bash: echo: write error: File exists
root@yoder-debian-bone:~/exercises/eQEP# dmesg | tail
    # [321550.694044] bone-capemgr bone_capemgr.9: slot #26: Failed verification
    # [325272.156839] bone-capemgr bone_capemgr.9: part_number 'PyBBIO-eqep2', version 'N/A'
    # [325272.157175] bone-capemgr bone_capemgr.9: slot #27: generic override
    # [325272.157484] bone-capemgr bone_capemgr.9: bone: Using override eeprom data at slot 27
    # [325272.157539] bone-capemgr bone_capemgr.9: slot #27: 'Override Board Name,00A0,Override Manuf,PyBBIO-eqep2'
    # [325272.162296] bone-capemgr bone_capemgr.9: slot #27: Requesting part number/version based 'PyBBIO-eqep2-00A0.dtbo
    # [325272.162358] bone-capemgr bone_capemgr.9: slot #27: Requesting firmware 'PyBBIO-eqep2-00A0.dtbo' for board-name 'Override Board Name', version '00A0'
    # [325272.185291] bone-capemgr bone_capemgr.9: slot #27: dtbo 'PyBBIO-eqep2-00A0.dtbo' loaded; converting to live tree
    # [325272.185847] bone-capemgr bone_capemgr.9: slot #27: PyBBIO-eqep2 conflict P8.41 (#5:BB-BONELT-HDMI)
    # [325272.196171] bone-capemgr bone_capemgr.9: slot #27: Failed verification
# There's a conflict with the HDMI pins.
# Try the other one
echo PyBBIO-eqep2b > $SLOTS
# That works!
