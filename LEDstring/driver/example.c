#include <linux/kobject.h>
#include <linux/sysfs.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <asm/uaccess.h>

#define DATA_LEN 10 // Length of data memory


/*
 * This is an example sysfs driver that creates a new kset called 
 * "example" inside "/sys/firmware/". It adds to this one kobject called 
 * "device". Inside "device" are the files for two  attributes: "test" 
 * and "data". The "test" attribute stores an integer, and the "data" 
 * attribute stores a string of length DATA_LEN (defined above).
 */
 

/*
 * This struct defines the attributes associated with our kobject.
 */
struct example_obj {
  struct kobject kobj;
  unsigned int test;
  char *data;
};
#define to_example_obj(x) container_of(x, struct example_obj, kobj)

/*
 * This struct contains the file operations for the kobject attributes.
 */
struct example_attr {
  struct attribute attr;
  ssize_t (*show)(struct example_obj *obj, struct example_attr *attr, char *buf);
  ssize_t (*store)(struct example_obj *obj, struct example_attr *attr, const char *buf, size_t count);
};
#define to_example_attr(x) container_of(x, struct example_attr, attr)

/*
 * This is boilerplate. It takes the attribute coming in and calls its
 * show function.
 */
static ssize_t example_attr_show(struct kobject *kobj, struct attribute *attr, char *buf) {
  struct example_attr *attribute;
  struct example_obj *obj;
  
  attribute = to_example_attr(attr);
  obj = to_example_obj(kobj);
  
  if (!attribute->show) {
    return -EIO;
  }
  return attribute->show(obj, attribute, buf);
}

/*
 * This is boilerplate. It takes the attribute coming in and calls its
 * store function.
 */
static ssize_t example_attr_store(struct kobject *kobj, struct attribute *attr, const char *buf, size_t len) {
  struct example_attr *attribute;
  struct example_obj *obj;
  
  attribute = to_example_attr(attr);
  obj = to_example_obj(kobj);
  
  if (!attribute->store) {
    return -EIO;
  }
  return attribute->store(obj, attribute, buf, len);
}

/*
 * This struct contains the sysfs file operations.
 */
static struct sysfs_ops example_sysfs_ops = {
  .show = example_attr_show,
  .store = example_attr_store
};

/*
 * Convenience function for freeing our kobject.
 */
static void example_release(struct kobject *kobj) {
  struct example_obj *obj;
  obj = to_example_obj(kobj);
  kfree(obj);
}

/*
 * This is the show function for our attributes. This will get called
 * whenever one of the sysfs files is read from.
 */
static ssize_t example_show(struct example_obj *obj, struct example_attr *attr, char *buf) {
  if (strcmp(attr->attr.name, "data") == 0) {
    return sprintf(buf, "%s", obj->data);
  } else if (strcmp(attr->attr.name, "test") == 0) {
    return sprintf(buf, "%u\n", obj->test);
  } else {
    return 0;
  }
}

/*
 * This is the store function for our attributes. This will get called
 * whenever one of the sysfs files is written to.
 */
static ssize_t example_store(struct example_obj *obj, struct example_attr *attr, const char *buf, size_t count) {
  if (strcmp(attr->attr.name, "data") == 0) {
    if (count <= DATA_LEN) {
      strcpy(obj->data, buf);
    }
    return count;
  } else if (strcmp(attr->attr.name, "test") == 0) {
    sscanf(buf, "%u", &obj->test);
    return count;
  } else {
    return 0;
  }
}

/*
 * These structs link the attributes with their files and sysfs 
 * functions.
 */
static struct example_attr test_attr = __ATTR(test, 0666, example_show, example_store);
static struct example_attr data_attr = __ATTR(data, 0666, example_show, example_store);

/*
 * This struct stores all of the attributes for our kobject.
 */
static struct attribute *example_default_attrs[] = {
  &test_attr.attr,
  &data_attr.attr,
  NULL
};

/*
 * This defines the structure of our kobject.
 */
static struct kobj_type example_ktype = {
  .sysfs_ops = &example_sysfs_ops,
  .release = example_release,
  .default_attrs = example_default_attrs
};

/*
 * These are used in initialization.
 */
static struct kset *example_kset;
static struct example_obj *test_obj;

/*
 * This creates a new kobject and adds it to our kset created in the
 * initialization.
 */
static struct example_obj *create_example_obj(const char *name) {
  struct example_obj *obj;
  int retval;
  
  obj = kzalloc(sizeof(*obj), GFP_KERNEL);
  if (!obj) {
    return NULL;
  }
    
  obj->kobj.kset = example_kset;

  obj->test = 0; 

  obj->data = kmalloc(DATA_LEN, GFP_KERNEL);
  if (!obj->data) {
    return NULL;
  }
  memset(obj->data, 0, DATA_LEN);
  
  retval = kobject_init_and_add(&obj->kobj, &example_ktype, NULL, "%s", name);
  if (retval) {
    kobject_put(&obj->kobj);
    return NULL;
  }
  
  kobject_uevent(&obj->kobj, KOBJ_ADD);
  
  return obj;
}

/*
 * This should call the kobject release function.
 */
static void destroy_example_obj(struct example_obj *obj) {
  kobject_put(&obj->kobj);
}

/*
 * This is the initialization function for the driver.
 */
static int __init example_init(void) {
  example_kset = kset_create_and_add("example", NULL, firmware_kobj);
  if (!example_kset) {
    kset_unregister(example_kset);
    printk("Example Driver Init Failed: %d\n", -ENOMEM);
    return -ENOMEM;
  }
  test_obj = create_example_obj("device");
  if (!test_obj) {
    destroy_example_obj(test_obj);
    kset_unregister(example_kset);
    printk("Example Driver Init Failed: %d\n", -EINVAL);
    return -EINVAL;
  }
  printk("Example Driver Added\n");
  return 0;
}

/*
 * This is the deinitialization function for the driver.
 */
static void __exit example_exit(void) {
  destroy_example_obj(test_obj);
  kset_unregister(example_kset);
  printk("Example Driver Removed\n");
}

module_init(example_init);
module_exit(example_exit);

MODULE_DESCRIPTION("EXAMPLE DRIVER");
MODULE_AUTHOR("GREG LARMORE & SEAN RICHARDSON");
MODULE_LICENSE("GPL");
