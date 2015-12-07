/* Example Minimal Character Device Driver */
// From page 211 of Embedded Linux Primer by Christopher Hallinan
#include <linux/module.h>

static int debug_enable = 0;
module_param(debug_enable, int, 0);
MODULE_PARM_DESC(debug_enable, "Enable module debug mode.");

static int __init hello_init(void) {
    /* Now print value of new module parameter */
    printk("Hello Example Init - debug mode is %s\n",
           debug_enable ? "enabled" : "disabled");
    return 0;
}

static void __exit hello_exit(void)
{
    printk(KERN_INFO "Hello Example Exit\n");
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_AUTHOR("Chris Hallinan, entered by Mark A. Yoder");
MODULE_DESCRIPTION("Hello World Example with parameter");
MODULE_LICENSE("GPL");
