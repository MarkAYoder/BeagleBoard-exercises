/**
 * @file   pwm.c
 * @author Mark A. Yoder, based on Derek Molloy's button.c 
 *       (http://derekmolloy.ie/kernel-gpio-programming-buttons-and-leds/)
 * @date   1-August-2016
 * @brief  A kernel module for controlling software pwm running on the PRU
 * The sysfs entry appears at /sys/ebb/gpio115
*/

#include <linux/module.h>
#include <linux/kobject.h>    // Using kobjects for the sysfs bindings
#include "../robotics_cape_defs.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Mark A. Yoder");
MODULE_DESCRIPTION("A pwm driver");
MODULE_VERSION("0.1");

static int channel = 0;                  /// Channel number
module_param(channel, int, S_IRUGO);      ///< Param desc. S_IRUGO can be read/not changed
MODULE_PARM_DESC(channel, " Channel number (default 0)");  ///< parameter description

static char   pwmName[8] = "pwmXXX";        ///< Null terminated default string -- just in case

#include <asm/io.h>
#define PRU_ADDR		0x4A300000		// Start of PRU memory Page 184 am335x TRM
#define PRU_LEN			0x80000			// Length of PRU memory
#define PRU_SHAREDMEM	0x10000			// Offset to shared memory
#define PRU_SHAREDMEM_LEN 0x3000       // Length of shared memory
#define PRU0_DRAM		0x00000			// Offset to DRAM
#define PRU1_DRAM		0x02000
#define ON  0     // 'on' value is stored first in array
#define OFF 1     // 'off' is second

void *mem;           // Pointer to start of PRU memory
void *shared_mem;    // Pointer to SHAREDMEM
void *dram0_mem;     // Pointer to PRU0 DRAM
void *dram1_mem;     // Pointer to PRU1 DRAM

// pwm_read() reads the ON time and OFF time for channel, ch.
// ON is the on time, OFF is the off time.
static int pwm_read(int ch, int item) {
   int value;
   if(ch<0) {
      printk(KERN_ALERT "pwm_read: channel=%d, must be > 0\n", ch);
      return -1;
   }
   if(ch<6) {  // Use PRU 0
      value = (int) ioread32(dram0_mem + 8*ch+4*item);
      printk(KERN_INFO "pwm_read PRU 0: ch=%d, item=%d, value=%d\n", ch, item, value);
      return value;
   }
   if(ch<SERVO_CHANNELS) { // Use PRU 1
      value = (int) ioread32(dram1_mem + 8*(ch-6)+4*item);
      printk(KERN_INFO "pwm_read PRU 1: ch=%d, item=%d, value=%d\n", ch, item, value);
      return value;
   }
   printk(KERN_INFO "pwm_read: channel=%d, must be < %d\n", ch, SERVO_CHANNELS);
   return -1;
}
// pwm_write() write the ON time or OFF time for channel, ch.
// ON is the on time, OFF is the off time.
static int pwm_write(int ch, int item, int value) {
   if(ch<0) {
      printk(KERN_ALERT "pwm_write: channel=%d, must be > 0\n", ch);
      return -1;
   }
   if(ch<6) {  // Use PRU 0
      iowrite32(value, dram0_mem + 8*ch+4*item);
      printk(KERN_INFO "pwm_write PRU 0: ch=%d, item=%d, value=%d\n", ch, item, value);
      return value;
   }
   if(ch<SERVO_CHANNELS) { // Use PRU 1
      iowrite32(value, dram1_mem + 8*(ch-6)+4*item);
      printk(KERN_INFO "pwm_write PRU 1: ch=%d, item=%d, value=%d\n", ch, item, value);
      return value;
   }
   printk(KERN_INFO "pwm_write: channel=%d, must be < %d\n", ch, SERVO_CHANNELS);
   return -1;
}

/** @brief Displays period in ns */
static ssize_t period_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf){
   return sprintf(buf, "%d\n", 
      PRU_PWM_LOOP_ns*(pwm_read(channel, ON) + pwm_read(channel, OFF))
      );
}

/** @brief Stores and sets the period in ns */
static ssize_t period_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count){
   int period;
   int on, off;    // on and off times in ns
   sscanf(buf, "%du", &period);
   // Subtract the on-time from the period to get the off time
   on = pwm_read(channel, ON);  // Get on time in loops
   off = (period-PRU_PWM_LOOP_ns*on)/PRU_PWM_LOOP_ns;     // Convert back to loops
   if(off<=0) {   // period is too small for the duty_cycle
      off = 1;
      pwm_write(channel, ON, period/PRU_PWM_LOOP_ns-1);
   }
   pwm_write(channel, OFF, off);
   printk(KERN_INFO "period: %dns\n", PRU_PWM_LOOP_ns*(on+off));
   return count;
}

/** @brief Displays duty_cycle in ns */
static ssize_t duty_cycle_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf){
   return sprintf(buf, "%d\n",  PRU_PWM_LOOP_ns*pwm_read(channel, ON));
}

/** @brief Stores and sets the duty_cycle (on-time) in ns */
// Keep the period the same
static ssize_t duty_cycle_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count){
   unsigned int duty;
   int on, off, period;
   on  = pwm_read(channel, ON);     // Get onand off times in loops
   off = pwm_read(channel, OFF);
   period = on + off;

   sscanf(buf, "%du", &duty); 
   on  = duty/PRU_PWM_LOOP_ns;
   off = period - on;      // Keep the same number of loops for period
   if(off<=0) {            // duty_cycle it too long for the period.  Set off time to 1.
      off=1;
   }
   
   pwm_write(channel, ON,  on);
   pwm_write(channel, OFF, off);
   
   printk(KERN_INFO "duty_cycle: %dns\n", duty);
   return count;
}
/** @brief Displays which channel is active */
static ssize_t channel_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf){
   return sprintf(buf, "%d\n", channel);
}

/** @brief Stores and sets the channel */
static ssize_t channel_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count){
   unsigned int new_channel;
   
   sscanf(buf, "%du", &new_channel); 

   if((new_channel>=0) && (new_channel<SERVO_CHANNELS)) {
      channel = new_channel;
      printk(KERN_INFO "channel: %d\n", channel);
   } else {
      printk(KERN_INFO "channel must be between 0 and %d. %d was given\n", SERVO_CHANNELS, new_channel);
   }
   return count;
}

/** @brief Displays enable */
static ssize_t enable_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf){
   return sprintf(buf, "%d\n", (ioread32(shared_mem+PRU_ENABLE)>>channel) & 0x1);
}

/** @brief Stores and sets the duty_cycle (on-time) in ns */
static ssize_t enable_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count){
   unsigned int temp;
   int enables;
   sscanf(buf, "%du", &temp);
   enables = ioread32(shared_mem+PRU_ENABLE);
   if(temp) {
      iowrite32(enables ^  (1<<channel), shared_mem+PRU_ENABLE);
   } else {
      iowrite32(enables & ~(1<<channel), shared_mem+PRU_ENABLE);
   }
   printk(KERN_INFO "enable: %d\n", temp);
   return count;
}

/**  Use these helper macros to define the name and access levels of the kobj_attributes
 *  The kobj_attribute has an attribute attr (name and mode), show and store function pointers
 *  The count variable is associated with the numberPresses variable and it is to be exposed
 *  with mode 0666 using the numberPresses_show and numberPresses_store functions above
 */
static struct kobj_attribute duty_cycle_attr = __ATTR(duty_cycle, 0660, duty_cycle_show, duty_cycle_store);
static struct kobj_attribute period_attr = __ATTR(period, 0660, period_show, period_store);
static struct kobj_attribute enable_attr = __ATTR(enable, 0660, enable_show, enable_store);
static struct kobj_attribute channel_attr = __ATTR(channel, 0660, channel_show, channel_store);

/**  The __ATTR_RO macro defines a read-only attribute. There is no need to identify that the
 *  function is called _show, but it must be present. __ATTR_WO can be  used for a write-only
 *  attribute but only in Linux 3.11.x on.
 */
// static struct kobj_attribute ledon_attr = __ATTR_RO(ledOn);     ///< the ledon kobject attr

/**  The ebb_attrs[] is an array of attributes that is used to create the attribute group below.
 *  The attr property of the kobj_attribute is used to extract the attribute struct
 */
static struct attribute *ebb_attrs[] = {
      &duty_cycle_attr.attr,
      &period_attr.attr,
      &enable_attr.attr,
      &channel_attr.attr,
      NULL,
};

/**  The attribute group uses the attribute array and a name, which is exposed on sysfs -- in this
 *  case it is gpio115, which is automatically defined in the pwm_init() function below
 *  using the custom kernel parameter that can be passed when the module is loaded.
 */
static struct attribute_group attr_group = {
      .name  = pwmName,                 ///< The name is generated in pwm_init()
      .attrs = ebb_attrs,               ///< The attributes array defined just above
};

static struct kobject *ebb_kobj;

/** @brief The LKM initialization function
 *  The static keyword restricts the visibility of the function to within this C file. The __init
 *  macro means that for a built-in driver (not a LKM) the function is only used at initialization
 *  time and that it can be discarded and its memory freed up after that point. In this example this
 *  function sets up the GPIOs and the IRQ
 *  @return returns 0 if successful
 */
static int __init pwm_init(void){
   int result = 0;
   printk(KERN_INFO "pwm: Initializing the pwm LKM\n");
   sprintf(pwmName, "pwm%d", channel);           // Create the gpio115 name for /sys/ebb/gpio115

   // create the kobject sysfs entry at /sys/ebb -- probably not an ideal location!
   ebb_kobj = kobject_create_and_add("pwm", kernel_kobj); // kernel_kobj points to /sys/kernel
   if(!ebb_kobj){
      printk(KERN_ALERT "pwm: failed to create kobject mapping\n");
      return -ENOMEM;
   }
   // add the attributes to /sys/ebb/ -- for example, /sys/ebb/gpio115/numberPresses
   result = sysfs_create_group(ebb_kobj, &attr_group);
   if(result) {
      printk(KERN_ALERT "pwm: failed to create sysfs group\n");
      kobject_put(ebb_kobj);                          // clean up -- remove the kobject sysfs entry
      return result;
   }

   // Mapping SHARED RAM
   mem = ioremap(PRU_ADDR, PRU_LEN);
   dram0_mem = mem + PRU0_DRAM + 0x200;
   dram1_mem = mem + PRU1_DRAM + 0x200;
   shared_mem= mem + PRU_SHAREDMEM;
   // Each channel's period and duty_cycle is stored in PRU DRAM memory as cycles ON
   // and cycles OFF.  |ch 0 on | ch 0 off | ch 1 on | ch1 off  etc.
   // Each is a 32 bit value.  Channel 0 starts at 0.  Channel 1 starts a 8, etc.
   //  The first 6 channels are on PRU 0, the remaining 12 are on PRU 1.
   // Enable bits are at the start of shared memory.
   printk(KERN_INFO "channel: %d, period: %d, duty_cycle: %d, enable: %d\n",
      channel,
      pwm_read(channel, ON) + pwm_read(channel, OFF),
      pwm_read(channel, ON),
      (ioread32(shared_mem+PRU_ENABLE)>>channel) & 0x1);

   return result;
}

/** @brief The LKM cleanup function
 *  Similar to the initialization function, it is static. The __exit macro notifies that if this
 *  code is used for a built-in driver (not a LKM) that this function is not required.
 */
static void __exit pwm_exit(void){
   kobject_put(ebb_kobj);                   // clean up -- remove the kobject sysfs entry
   printk(KERN_INFO "pwm: Goodbye from the EBB Button LKM!\n");
   iounmap(mem);
   printk(KERN_INFO "iounmap(mem)\n");
}

// This next calls are  mandatory -- they identify the initialization function
// and the cleanup function (as above).
module_init(pwm_init);
module_exit(pwm_exit);
