#!/bin/bash
# This is for updating bonescript for ASEE 2013
# On the host
wget http://s3.amazonaws.com/beagle/bone101_1.0-r2.3_all.ipk
wget http://s3.amazonaws.com/beagle/bonescript_1.0-r21.4_armv7a-vfp-neon.ipk
scp bone101_1.0-r2.3_all.ipk root@192.168.7.2:
scp bonescript_1.0-r21.4_armv7a-vfp-neon.ipk root@192.168.7.2:

# On the bone
ssh root@192.168.7.2 systemctl stop bonescript
ssh root@192.168.7.2 opkg install bone101_1.0-r2.3_all.ipk
ssh root@192.168.7.2 opkg install bonescript_1.0-r21.4_armv7a-vfp-neon.ipk 

# Now, follow the instructions at http://beagleboard.org/support/BoneScript/wired_basic_test/ to confirm a good installation.
#  You should also check out
# http://192.168.7.2/Support/BoneScript/readTextFile/ and, when run,
# it should give you something like:
#  Bonescript: initialized
#  x.data = Cloud9 GNOME Image 2013.05.08

#  x.err = null
