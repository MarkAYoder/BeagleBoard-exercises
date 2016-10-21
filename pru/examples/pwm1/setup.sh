# This sets things up for compiling
# Enable remote proc by following: http://elinux.org/EBC_Exercise_30_PRU_via_remoteproc_and_RPMsg

export PRU_CGT=/usr/share/ti/cgt-pru
export PRU_SUPPORT=/opt/source/pru-software-support-package

config-pin -a P9_27 pruout
config-pin -a P9_28 pruin
