#!/usr/bin/env python3

import glob

NULL=0
module = 0
sysfs  = 1
index  = 2
muxmode= 3
path   = 4
name   = 5
chip   = 6
addr   = 7
key    = 8

pwm_table = [
  [ "ehrpwm2", 6, 1, 4, "ehrpwm.2:1", "EHRPWM2B", "48304000", "48304200", "P8_13"],
  [ "ehrpwm2", 5, 0, 4, "ehrpwm.2:0", "EHRPWM2A", "48304000", "48304200", "P8_19"],
  [ "ehrpwm1", 4, 1, 2, "ehrpwm.1:1", "EHRPWM1B", "48302000", "48302200", "P8_34"],
  [ "ehrpwm1", 3, 0, 2, "ehrpwm.1:0", "EHRPWM1A", "48302000", "48302200", "P8_36"],
  [ "ehrpwm2", 5, 0, 3, "ehrpwm.2:0", "EHRPWM2A", "48304000", "48304200", "P8_45"],
  [ "ehrpwm2", 6, 1, 3, "ehrpwm.2:1", "EHRPWM2B", "48304000", "48304200", "P8_46"],
  [ "ehrpwm1", 3, 0, 6, "ehrpwm.1:0", "EHRPWM1A", "48302000", "48302200", "P9_14"],
  [ "ehrpwm1", 4, 1, 6, "ehrpwm.1:1", "EHRPWM1B", "48302000", "48302200", "P9_16"],
  [ "ehrpwm0", 1, 1, 3, "ehrpwm.0:1", "EHRPWM0B", "48300000", "48300200", "P9_21"],
  [ "ehrpwm0", 0, 0, 3, "ehrpwm.0:0", "EHRPWM0A", "48300000", "48300200", "P9_22"],
  [   "ecap2", 7, 0, 4, "ecap.2",     "ECAPPWM2", "48304000", "48304100", "P9_28"],
  [ "ehrpwm0", 1, 1, 1, "ehrpwm.0:1", "EHRPWM0B", "48300000", "48300200", "P9_29"],
  [ "ehrpwm0", 0, 0, 1, "ehrpwm.0:0", "EHRPWM0A", "48300000", "48300200", "P9_31"],
  [   "ecap0", 2, 0, 0, "ecap.0",     "ECAPPWM0", "48300000", "48300100", "P9_42"],
  [ "timer4", 0, 0, 2, "", "", "", "dmtimer-pwm-4", "P8_7" ],
  [ "timer7", 0, 0, 2, "", "", "", "dmtimer-pwm-7", "P8_8" ],
  [ "timer5", 0, 0, 2, "", "", "", "dmtimer-pwm-5", "P8_9" ],
  [ "timer6", 0, 0, 2, "", "", "", "dmtimer-pwm-6", "P8_10" ],
  [ "ehrpwm0", 0, 0, 1, "ehrpwm.0:0", "EHRPWM0A", "48300000", "48300200", "P1_8"],
  [ "ehrpwm0", 0, 0, 1, "ehrpwm.0:0", "EHRPWM0A", "48300000", "48300200", "P1_36"],
  [ "ehrpwm0", 1, 1, 1, "ehrpwm.0:1", "EHRPWM0B", "48300000", "48300200", "P1_10"],
  [ "ehrpwm0", 1, 1, 1, "ehrpwm.0:1", "EHRPWM0B", "48300000", "48300200", "P1_33"],
  [ "ehrpwm1", 3, 0, 6, "ehrpwm.1:0", "EHRPWM1A", "48302000", "48302200", "P2_1"],
  [ "ehrpwm2", 6, 1, 3, "ehrpwm.2:1", "EHRPWM2B", "48304000", "48304200", "P2_3"],
  [ "timer7", 0, 0, 4, "", "", "", "dmtimer-pwm-7", "P1_20" ],
  [ "timer6", 0, 0, 1, "", "", "", "dmtimer-pwm-6", "P1_26" ],
  [ "timer5", 0, 0, 1, "", "", "", "dmtimer-pwm-5", "P1_28" ],
  [ "timer7", 0, 0, 5, "", "", "", "dmtimer-pwm-7", "P2_27" ],
  [ "timer4", 0, 0, 2, "", "", "", "dmtimer-pwm-4", "P2_31" ],
#   [ NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL ]
]

print(pwm_table[2][key])
print(len(pwm_table))

def get_pwm_key(channel):
    for i in range(len(pwm_table)):
        if pwm_table[i][key] == channel:
            return pwm_table[i]

def get_pwm_path(channel):
    x = get_pwm_key(channel)
    if x != None:
        pwmPath =  glob.glob("/sys/devices/platform/ocp/" + x[chip] + ".epwmss/" 
                + x[addr] + ".pwm/pwm/*")[0] + "/export"
        print(pwmPath)
        # print(glob.glob(pwmPath))
        
print(get_pwm_key("P9_14"))

print(get_pwm_path("P9_14"))