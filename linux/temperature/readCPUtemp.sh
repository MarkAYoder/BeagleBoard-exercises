#!/bin/bash
# Reads internal temperature of AM335x
# 0x44e1_0000 is the starting address of the Control Module (Table 2.2 p 171 of TRM)
# 0x0448 is the address of the bandgap_crtl register which has 
#           8 bits (8-15) of temperature (Table 9-19 p 1137)
devmem2 0x44e10448 w
devmem2 0x44e10449 b
cat /sys/devices/ocp.2/44e10448.bandgap/temp1_input