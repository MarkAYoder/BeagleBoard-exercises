#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/jiffies.h>
#include <linux/delay.h> // for usleep_range
#include <linux/gpio.h>
#include <linux/fs.h>
#include <linux/device.h>
#include <linux/sysfs.h>
#include <asm/uaccess.h>
#include <linux/kobject.h>
#include <linux/sched.h>

#include <asm/io.h> // for talking to gpio
#include <mach/platform.h> // for talkint to gpio

// SANDRA, STOP dereferencing variable use the iowrite32 function!!!!!
// utility functions

//#define DISABLE_KERNEL_PREEMPTION 1
// uncomment #define DISABLE_KERNEL_PREEMPTION if you wish to disable kernel preemption

#define MAXLOOP 10000

static inline unsigned ccnt_read (void)
{
    unsigned cc;
    asm volatile ("mrc p15, 0, %0, c15, c12, 1" : "=r" (cc));
    return cc;
}

// GPIO - structure reflects registers as defined in the Broadcom h/w spec
// https://www.raspberrypi.org/wp-content/uploads/2012/02/BCM2835-ARM-Peripherals.pdf
struct gpio_registers
{
    uint32_t GPFSEL[6];
    uint32_t Reserved1;
    uint32_t GPSET[2];
    uint32_t Reserved2;
    uint32_t GPCLR[2];
    uint32_t Reserved3;
    uint32_t GPLEV0[2];
    uint32_t Reserved4;
};

struct gpio_registers *gpio_regs;
#define GPIO_OUT 0b001
#define GPIO_ON true
#define GPIO_OFF false

// set the gpio pin - input, output or alt function
static void set_gpio_altfunc(int gpio, int altfunc)
{
    int reg_index = gpio / 10;
    int bit = (gpio % 10) * 3;

    unsigned old_value = gpio_regs->GPFSEL[reg_index];
    unsigned mask = 0b111 << bit;
    printk("Changing function of GPIO%d from %x to %x\n",
           gpio,
           (old_value >> bit) & 0b111,
           altfunc);

    gpio_regs->GPFSEL[reg_index] =
        (old_value & ~mask) | ((altfunc << bit) & mask);
}

static void set_gpio_output_value(int gpio,  bool value)
{
    if (value)
        gpio_regs->GPSET[gpio/32] = (1 << (gpio % 32));
    else
        gpio_regs->GPCLR[gpio/32] = (1 << (gpio % 32));
}


// probe - ideas - do setup, get device tree information
// (e.g. pulse width parms), and set up the ISR
// then start a pthread that can wait for a sysfs write
// (poll or function sysfs) to tell it to do the first
// pulse, and it will continue to do the pulses, incrementing
// length based on the pulse width parms.  When the interrupt
// comes, it will imeediately drop the pulse, and stop any future
// pulses until the next sysfs request

//SANDRA, need to add protected variable for current gpio state
// When the interrupt happens, only set low if state is hi
// when the hrtimer finishes the sleep, only set low if state is hi
// Also another one for gpio_complete, and when set (only in the int), the
// main thread won't do any new pulses if gpio_complete is set.


static void run_pulse_test(int pulse_width, int gpio_pin);

// objects/vars accessible to user
static int Gpio_pin_to_drive = 4;  // default to 4, J8 Pin 7
// note that the Shortest and Longest pulse_widths are stored in nsec,
static int Shortest_pulse_width = 0x7FFFFFFF;  // biggest signed value
static int Longest_pulse_width = 0;
// but User_pulse_width is stored in usec
static int User_pulse_width = 10 * 1000; // default to 10 ms
// accumulated values to compute average
static long long Run_time_average = 1;
static int Average_divider = 1;

static uint8_t Stop_loop = 0;

enum user_delay_enum_type {mdelay_type, usleep_type, end_delay_types};
// busy wait or kernel sleep for delay?
static enum user_delay_enum_type User_delay_type = mdelay_type;

static int get_average_pulse_width(void)
{
    long hold_numerator;
    int average;

    printk("Sandra, Run_time_average=%lld Average_divider=%d\n", Run_time_average, Average_divider);
    if (Average_divider == 1)
    {
        return 0;
    }

    hold_numerator = Run_time_average;
//    remainder = do_div(hold_numerator, Average_divider);
    average = (int) div64_s64(Run_time_average, Average_divider);
    printk("%s: average=%d, divider=%d\n",
           __func__, average, Average_divider);
    return average;
}
static void do_the_delay_or_sleep(int usec_min, int usec_max)
{
    if (User_delay_type == mdelay_type)
    {
        if (usec_min > 1000)
        {
            mdelay(usec_min/1000); // convert usec to msec
        }
        else
        {
            udelay(usec_min);
        }

    }
    else if (User_delay_type == usleep_type)
    {
        usleep_range(usec_min, usec_max);
    }
}

ssize_t show_pulse_width(struct device *dev,
                         struct device_attribute *attr, char *buf)
{
    printk("%s, %d usec\n", __func__, User_pulse_width);
    return sprintf(buf, "User set pulse width of %d usec\n",
                   User_pulse_width);
}

ssize_t show_pulse_results(struct device *dev,
                           struct device_attribute *attr, char *buf)
{
    printk("%s, L=%dnsec, S=%dnsec\n", __func__,
           Longest_pulse_width, Shortest_pulse_width);
    return sprintf(buf, "Results: longest=%dnsec, shortest=%dnsec, ave=%dnsec\n",
                   Longest_pulse_width, Shortest_pulse_width,
                   get_average_pulse_width());
}

ssize_t show_gpio_pin(struct device *dev,
                      struct device_attribute *attr, char *buf)
{
    printk("%s, Driving gpio pin %d\n", __func__, Gpio_pin_to_drive);
    return sprintf(buf, "Driving gpio pin %d\n", Gpio_pin_to_drive);
}

ssize_t show_user_delay_type(struct device *dev,
                             struct device_attribute *attr, char *buf)
{
    if (User_delay_type == mdelay_type)
    {
        return sprintf(buf, "mdelay - busy/wait (val=%d)\n", User_delay_type);
    }
    else if (User_delay_type == usleep_type)
    {
        return sprintf(buf, "usleep_range, letting the kernel sleep (val=%d)\n", User_delay_type);
    }
    return 0; // should never reach here
}

// NOTE: user needs to set pulse width in usec
ssize_t set_pulse_width(struct device *dev, struct device_attribute *attr,
                        const char *buf, size_t len)
{
    int r;

    r = kstrtoint(buf, 10, &User_pulse_width);
    printk("%s: setting pulse width to %dusec\n", __func__, User_pulse_width);
    return r ? 0 : len;
}

ssize_t start_pulse_run(struct device *dev, struct device_attribute *attr,
                        const char *buf, size_t len)
{
    printk("%s: starting, width of %dusec\n", __func__, User_pulse_width);
    run_pulse_test(User_pulse_width, Gpio_pin_to_drive);
    return len;
}

ssize_t set_gpio_pin(struct device *dev, struct device_attribute *attr,
                     const char *buf, size_t len)
{
    int r;

    printk("%s\n", __func__);
    r = kstrtoint(buf, 10, &Gpio_pin_to_drive);
    set_gpio_altfunc(Gpio_pin_to_drive, GPIO_OUT);
    return (r ? 0 : len);
}

ssize_t set_user_delay_type(struct device *dev, struct device_attribute *attr,
                            const char *buf, size_t len)
{
    int r, hold_delay_type;

    printk("%s\n", __func__);
    r = kstrtoint(buf, 10, &hold_delay_type);
    if (hold_delay_type < end_delay_types)
    {
        User_delay_type = (enum user_delay_enum_type) hold_delay_type;
    }
    return (r ? 0 : len);
}

ssize_t set_stop_loop(struct device *dev, struct device_attribute *attr,
                 const char *buf, size_t len)
{
    printk("%s\n", __func__);

    Stop_loop = 1;
    return (len);
}



static void run_pulse_test(int pulse_width, int gpio_pin)
{
    int i, loopsize, x, sched_ret;
    struct timespec starttime, endtime, deltatime;
    const int cpu = 3; // /boot/cmdline.txt has isolcpus=3, so only we are on it
    const struct sched_param sched_param = {.sched_priority = 99}; // highest rt priority
    cpumask_t save_allowed;

    Stop_loop = 0;
    Run_time_average = 0;
    if (User_delay_type == 0)
    {
        printk(KERN_INFO "doing mdelay - busy/wait\n");
    }
    else
    {
        printk(KERN_INFO "doing usleep_range, letting the kernel sleep\n");
    }
    printk(KERN_INFO "running pulse test - my pid is %d\n", current->pid);

    save_allowed = current->cpus_allowed;
    // set the cpu affinity of this process
    if (set_cpus_allowed_ptr(current, cpumask_of(cpu)) != 0)
    {
        printk(KERN_ERR "cpu affinity returned error\n");
    }
    // set scheduler to RT SCHED_FIFO
    sched_ret = sched_setscheduler(current, SCHED_FIFO, &sched_param);
    if (sched_ret != 0)
    {
        printk(KERN_ERR "Setting scheduling to SCHED_FIFO returned error %d\n", sched_ret);
    }
#ifdef DISABLE_KERNEL_PREEMPTION
    get_cpu();
#endif

    // initialize values
    Shortest_pulse_width = 0x7FFFFFFF;  // biggest signed value
    Longest_pulse_width = 0;


    // start with value low
    set_gpio_output_value(gpio_pin, GPIO_OFF);
    loopsize = MAXLOOP;  // to make a shorter test, set loopsize to a smaller value
    x = MAXLOOP/pulse_width;
    // make the loopsize longer for short pulse widths
    printk("sandra remove MAXLOOP=%d, pulsewidth  =%d x=%d\n", MAXLOOP, pulse_width, x);
    loopsize *= x;

    printk("loopsize is %d\n",loopsize);
    for (i=0; i < loopsize; i++)
    {
        if (Stop_loop != 0)
        {
            break;
            // get out of here
        }
        getnstimeofday(&starttime);
        set_gpio_output_value(gpio_pin, GPIO_ON);

// will we have a problem with interrupts since this is uninterruptible?  or will the isr fire fine?
        do_the_delay_or_sleep(pulse_width, pulse_width);
        set_gpio_output_value(gpio_pin, GPIO_OFF);
        getnstimeofday(&endtime);

// sleep to make the pulse obvious on oscope
        do_the_delay_or_sleep(pulse_width * 2, pulse_width * 2);
        deltatime = timespec_sub(endtime, starttime);
        if (deltatime.tv_sec != 0)
        {
            printk(KERN_ERR "we had %lu second delay!!!!!  ERROR\n", deltatime.tv_sec);
        }

        if (deltatime.tv_nsec < Shortest_pulse_width)
        {
            Shortest_pulse_width = deltatime.tv_nsec;
            printk(KERN_INFO "shortest time is now %d\n",
                   Shortest_pulse_width);
        }
        if (deltatime.tv_nsec > Longest_pulse_width)
        {
            Longest_pulse_width = deltatime.tv_nsec;
            printk(KERN_INFO "longest time is now %d\n",
                   Longest_pulse_width);
        }
        // keep an average
        Run_time_average += deltatime.tv_nsec;
        Average_divider = i+1;
    }
#ifdef DISABLE_KERNEL_PREEMPTION
    put_cpu();
#endif
    // put this task back on the un-isolated CPU core (restore the cpu affinity)
    set_cpus_allowed_ptr(current, &save_allowed);
    printk(KERN_INFO "longest %dnsec, shortest time was %dnsec, ave=%dnsec\n",
           Longest_pulse_width, Shortest_pulse_width,
           get_average_pulse_width());
}

#undef VERIFY_OCTAL_PERMISSIONS
#define VERIFY_OCTAL_PERMISSIONS(perms) (perms)

static DEVICE_ATTR(pulse_run, S_IWUSR | S_IRUGO, show_pulse_results, start_pulse_run);
static DEVICE_ATTR(gpio_pin, S_IWUSR | S_IRUGO, show_gpio_pin, set_gpio_pin);
static DEVICE_ATTR(pulse_width, S_IWUSR | S_IRUGO, show_pulse_width, set_pulse_width);
static DEVICE_ATTR(user_delay_type, S_IWUSR | S_IRUGO, show_user_delay_type, set_user_delay_type);
static DEVICE_ATTR(stop_run, S_IWUSR, NULL, set_stop_loop);

static struct kobject *kobj;

static int __init gpio_pulse_init(void)
{
    kobj = kobject_create_and_add("gpio_control", NULL);
    if (kobj == NULL)
    {
        printk(KERN_ERR "kobj could not be created!!\n");
        return -1;
    }

    if (sysfs_create_file(kobj, &dev_attr_pulse_run.attr) != 0)
    {
        printk(KERN_ERR "sysfs_create_file of pulse_run attr returned non 0 value\n");
    }
    if (sysfs_create_file(kobj, &dev_attr_gpio_pin.attr) != 0)
    {
        printk(KERN_ERR "sysfs_create_file of gpio_pin attr returned non 0 value\n");
    }
    if (sysfs_create_file(kobj, &dev_attr_pulse_width.attr) != 0)
    {
        printk(KERN_ERR "sysfs_create_file of pulse_width attr returned non 0 value\n");
    }
    if (sysfs_create_file(kobj, &dev_attr_user_delay_type.attr) != 0)
    {
        printk(KERN_ERR "sysfs_create_file of user_delay_type attr returned non 0 value\n");
    }
    if (sysfs_create_file(kobj, &dev_attr_stop_run.attr) != 0)
    {
        printk(KERN_ERR "sysfs_create_file of stop_run attr returned non 0 value\n");
    }

    // set up gpio access
    gpio_regs = (struct gpio_registers *)__io_address(GPIO_BASE);
    // set up the default gpio pin,
    set_gpio_altfunc(Gpio_pin_to_drive, GPIO_OUT);

    return 0;
}

static void __exit gpio_pulse_exit(void)
{
    printk(KERN_INFO "Exiting: cleanup\n");

    // remove the sysfs files
    sysfs_remove_file(kobj, &dev_attr_pulse_width.attr);
    sysfs_remove_file(kobj, &dev_attr_gpio_pin.attr);
    sysfs_remove_file(kobj, &dev_attr_pulse_run.attr);
    sysfs_remove_file(kobj, &dev_attr_user_delay_type.attr);
    // remove the kernel object
    kobject_put(kobj);
}

module_init(gpio_pulse_init);
module_exit(gpio_pulse_exit);


MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Control gpio pulse with < 1msec accuracy");
MODULE_VERSION("Jan 1 2017");
