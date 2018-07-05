# This is a example of ARM to PRU communication from Lab 5 of
# http://processors.wiki.ti.com/index.php/PRU_Training:_Hands-on_Labs#LAB_5:_RPMsg_Communication_between_ARM_and_PRU

LAB_5=/opt/source/pru-software-support-package/labs/lab_5
# Or http://git.ti.com/pru-software-support-package/pru-software-support-package/trees/master/labs/lab_5

cp $LAB_5/solution/PRU_RPMsg_Echo_Interrupt1/main.c .
cp $LAB_5/solution/PRU_RPMsg_Echo_Interrupt1/resource_table_1.h .
cp $LAB_5/rpmsg_pru_user_space_echo.c .

wget https://github.com/torvalds/linux/raw/master/samples/rpmsg/rpmsg_client_sample.c

sudo apt install linux-headers-`uname -r`