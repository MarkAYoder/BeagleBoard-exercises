These are my notes for Assembly instructions for the TI-RSLK MAX Kit (Pololu item #3670)
https://www.pololu.com/docs/0J79

# base pin map
https://www.ti.com/lit/ml/sekp171/sekp171.pdf?ts=1592316384256

# Schematic
https://www.pololu.com/file/0J1670/ti-rslk-max-chassis-board-v1.0-schematic.pdf

# TI's site
https://university.ti.com/programs/RSLK/

# User guide
https://www.ti.com/lit/ml/sekp166/sekp166.pdf?ts=1592316473606

# Software
wget http://users.ece.utexas.edu/~valvano/arm/tirslk_max_1_00_00.zip

# Wiring
|====
|Pocket|TI-RSLK

|P1_36 |J4 - PWMR
|P2_1  |J4 - PWML
|P2_3  |J2 - ERB
|P2_4  |J2 - ELB
|P1_34 |J3 - DIRR
|P2_8  |J3 - DIRL 

# Controlling with librobotcontrol.

bone$ git clone  https://github.com/MarkAYoder/librobotcontrol.git
bone$ librobotcontrol/library
bone$ make
bone$ sudo make install

bone$ cd ../examples
bone$ make
bone$ bin/bin/rc_test_motors -s 0.1
