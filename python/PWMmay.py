#!/usr/bin/env python3

import glob
import time

t_NULL=0
t_module = 0
t_sysfs  = 1
t_index  = 2
t_muxmode= 3
t_path   = 4
t_name   = 5
t_chip   = 6
t_addr   = 7
t_key    = 8

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

# print(pwm_table[2][t_key])
# print(len(pwm_table))

def get_pwm_key(channel):
    for i in range(len(pwm_table)):
        if pwm_table[i][t_key] == channel:
            return pwm_table[i]

def get_pwm_path(channel):
    x = get_pwm_key(channel)
    if x != None:
        pwmPath =  glob.glob("/sys/devices/platform/ocp/" + x[t_chip] + ".epwmss/" 
                + x[t_addr] + ".pwm/pwm/*")[0]
        # print(pwmPath)
        return [pwmPath, x[t_index]]

#PWM.start(channel, duty, freq=2000, polarity=0)

def start(channel, duty, freq=2000, polarity=0):
    path = get_pwm_path(channel)
    # /sys/devices/platform/ocp/48302000.epwmss/48302200.pwm/pwm/pwmchip4/pwm-4:0
    pathpwm = path[0] + "/pwm-" + path[0][-1] + ':' + str(path[1])
    print(pathpwm)

    period_ns = 1e9 / freq
    duty_ns = period_ns * (duty / 100.0)
    print(duty_ns)
    
    # export
    try:
        fd = open(path[0] + "/export", 'w')
        fd.write(str(path[1])) 
        fd.close()
    except:
        pass
    time.sleep(0.05)    # Give export a chance
    
    # Duty Cycle
    fd = open(pathpwm + "/duty_cycle", 'w')
    fd.write('0')
    fd.close()

    # Period
    fd = open(pathpwm + "/period", 'w')
    fd.write(str(int(period_ns)))
    fd.close()

    # Duty Cycle
    fd = open(pathpwm + "/duty_cycle", 'w')
    fd.write(str(int(duty_ns)))
    fd.close()

    # Enable
    fd = open(pathpwm + "/enable", 'w')
    fd.write('1')
    fd.close()

def set_frequency(channel, freq):
    path = get_pwm_path(channel)
    # /sys/devices/platform/ocp/48302000.epwmss/48302200.pwm/pwm/pwmchip4/pwm-4:0
    pathpwm = path[0] + "/pwm-" + path[0][-1] + ':' + str(path[1])

    # compute current duty cycle
    fd = open(pathpwm + "/duty_cycle", 'r')
    duty_cycle_ns = int(fd.read()[:-1] )       # Remove \n at end
    fd.close()
    
    fd = open(pathpwm + "/period", 'r')
    period_ns = int(fd.read()[:-1])
    fd.close()
    
    duty_cycle = duty_cycle_ns/period_ns          # compute current duty cycle as fraction
    period_ns = 1e9 / freq                  # compute new period
    duty_cycle_ns = period_ns*duty_cycle # compute new duty cycle as fraction of period

    print('duty_cycle: ' + str(duty_cycle))
    print('period_ns: ' + str(period_ns))
    print('duty_cycle_ns: ' + str(duty_cycle_ns))

    # Duty Cycle - Set to 0
    fd = open(pathpwm + "/duty_cycle", 'w')
    fd.write('0')
    fd.close()
    
    # Period
    fd = open(pathpwm + "/period", 'w')
    fd.write(str(int(period_ns)))
    fd.close()

    # Duty Cycle
    fd = open(pathpwm + "/duty_cycle", 'w')
    fd.write(str(int(duty_cycle_ns)))
    fd.close()

def set_duty_cycle(channel, duty):
    path = get_pwm_path(channel)
    # /sys/devices/platform/ocp/48302000.epwmss/48302200.pwm/pwm/pwmchip4/pwm-4:0
    pathpwm = path[0] + "/pwm-" + path[0][-1] + ':' + str(path[1])

    fd = open(pathpwm + "/period", 'r')
    period_ns = int(fd.read()[:-1])
    fd.close()

    duty_cycle_ns = duty/100 * period_ns
    # Duty Cycle
    fd = open(pathpwm + "/duty_cycle", 'w')
    fd.write(str(int(duty_cycle_ns)))
    fd.close()
    
def stop(channel):
    path = get_pwm_path(channel)
    pathpwm = path[0] + "/pwm-" + path[0][-1] + ':' + str(path[1])
   
    # Disable
    fd = open(pathpwm + "/enable", 'w')
    fd.write('0')
    fd.close()

    # unexport
    fd = open(path[0] + "/unexport", 'w')
    fd.write(str(path[1])) 
    fd.close()
