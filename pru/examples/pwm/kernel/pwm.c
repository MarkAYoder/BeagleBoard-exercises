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
void *shared_mem;     // Pointer to SHAREDMEM

/** @brief Displays period in ns */
static ssize_t period_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf){
   return sprintf(buf, "%d\n", ioread32(shared_mem+8*channel)+ioread32(shared_mem+8*channel+4));
}

/** @brief Stores and sets the period in ns */
static ssize_t period_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count){
   unsigned int temp;
   sscanf(buf, "%du", &temp);
   // Subtract the on-time from the period to get the 
   iowrite32(temp-ioread32(shared_mem+8*channel), shared_mem+8*channel+4);
   printk(KERN_INFO "period: %d\n", temp);
   return count;
}

/** @brief Displays duty_cycle in ns */
static ssize_t duty_cycle_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf){
   return sprintf(buf, "%d\n", ioread32(shared_mem+8*channel));
}

/** @brief Stores and sets the duty_cycle (on-time) in ns */
static ssize_t duty_cycle_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count){
   unsigned int temp;
   sscanf(buf, "%du", &temp); 
   iowrite32(temp, shared_mem+8*channel);
   printk(KERN_INFO "duty_cycle: %d\n", temp);
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
   ebb_kobj = kobject_create_and_add("pwm", kernel_kobj->parent); // kernel_kobj points to /sys/kernel
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
   shared_mem = ioremap(PRU_ADDR+PRU_SHAREDMEM, 0x3000);
   // Each channel's period and duty_cycle is stored in shared memory as cycles on
   // and cycles off.  |ch 0 on | ch 0 off | ch 1 on | ch1 off \ etc.
   // Each is a 32 bit value.  Channel 0 starts at 0.  Channel 1 starts a 8, etc.
   //  shared_mem+8*channel is the addres of 'channel' on time and
   //  shared_mem+8*chennel+4 is the off time.
   // Enable bits are at the end at 12*8=96.
   printk(KERN_INFO "channel: %d, period: %d, duty_cycle: %d, enable: %d\n",
      channel,
      ioread32(shared_mem+8*channel)+ioread32(shared_mem+8*channel+4),
      ioread32(shared_mem+8*channel),
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
   iounmap(shared_mem);
   printk(KERN_INFO "iounmap(shared_mem)\n");
}

// This next calls are  mandatory -- they identify the initialization function
// and the cleanup function (as above).
module_init(pwm_init);
module_exit(pwm_exit);
