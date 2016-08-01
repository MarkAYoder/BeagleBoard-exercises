### pwm
16 channel pwm.  6 channels are on PRU 0 and 12 on PRU 1.  Shared memory is used to control the pulse on and off time. See `pwm-test.c` for an example of using mmap() on the ARM to control the pwms.

Run the programs in this order:

1.  Go to [http://elinux.org/EBC_Exercise_30_PRU_via_remoteproc_and_RPMsg] for instructions on how to set up your Bone for PRU development via remoteproc.
2.  `./setup.sh`  - Runs config-pin to make set all pin muxes to pruout
2.  `make pwm-test`   - Compile pwm-test.c
3.  `./pwm-test`      - Writes the on/off times into shared memory
4.  `make install`    - Compiles the PRU code and starts running it
 
`./setup.sh` only needs to be run once per boot up.

pru-pwm.asm assembles code for both PRUs.  When PRU_NUM is set to 0, code for PRU 0 is generated.  The Makefile knows to generate for both PRUs.

INITC is use to synchronize both PRUs, so the pulses are start together (with 1ns).

More channels could be generated if the emmc were disabled.

Currently the PRU 0 pwm channels use the same on/off times at PRU 1.  This should be fixed.
