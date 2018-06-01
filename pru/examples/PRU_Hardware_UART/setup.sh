# Configure tx
config-pin P9_24 pru_uart
# Configure rx
config-pin P9_26 pru_uart

export PRU_CGT=/usr/share/ti/cgt-pru
export PRU_SUPPORT=/opt/source/pru-software-support-package

export PRUN=0
export TARGET=uart1