#include <linux/kobject.h>
#include <linux/sysfs.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <asm/uaccess.h>
#include <linux/spi/spi.h>

#define DRIVER_NAME "lpd8806"

#define STRAND_LEN 160 // Length of data memory

//SPI 2.0 running at 10Mhz
#define SPI_BUS_NUM 2
#define SPI_BUS_SPEED 10000000
#define SPI_CS 0


/*
 * This is a sysfs driver for 5m light strand made by Adafruit:
 * 
 * http://adafruit.com/products/306
 * 
 * The driver creates a new kset called "lpd8806" inside 
 * "/sys/firmware/". It adds to this one kobject called "device". 
 * Inside "device" are the files for two attributes: "data" and "grb".
 * The "data" attribute stores the state of the strand, and the "grb"
 * attribute stores the status of the first LED.
 * 
 */

/*
 * This is the spi device we will be using
 */
static struct spi_device *device;


/*
 * This struct defines the attributes associated with out kobject.
 */
struct lpd8806_obj {
  struct kobject kobj;
  unsigned char grb[3];
  unsigned char data[STRAND_LEN * 3];
};
#define to_lpd8806_obj(x) container_of(x, struct lpd8806_obj, kobj)

/*
 * This struct contains the file operations for the kobject attributes.
 */
struct lpd8806_attr {
  struct attribute attr;
  ssize_t (*show)(struct lpd8806_obj *obj, struct lpd8806_attr *attr, char *buf);
  ssize_t (*store)(struct lpd8806_obj *obj, struct lpd8806_attr *attr, const char *buf, size_t count);
};
#define to_lpd8806_attr(x) container_of(x, struct lpd8806_attr, attr)

/*
 * This is boilerplate. It takes the attribute coming in and calls its
 * show function.
 */
static ssize_t lpd8806_attr_show(struct kobject *kobj, struct attribute *attr, char *buf) {
  struct lpd8806_attr *attribute;
  struct lpd8806_obj *obj;
  
  attribute = to_lpd8806_attr(attr);
  obj = to_lpd8806_obj(kobj);
  
  if (!attribute->show) {
    return -EIO;
  }
  return attribute->show(obj, attribute, buf);
}

/*
 * This is boilerplate. It takes the attribute coming in and calls its
 * store function.
 */
static ssize_t lpd8806_attr_store(struct kobject *kobj, struct attribute *attr, const char *buf, size_t len) {
  struct lpd8806_attr *attribute;
  struct lpd8806_obj *obj;
  
  attribute = to_lpd8806_attr(attr);
  obj = to_lpd8806_obj(kobj);
  
  if (!attribute->store) {
    return -EIO;
  }
  return attribute->store(obj, attribute, buf, len);
}

/*
 * This struct contains the sysfs file operations.
 */
static struct sysfs_ops lpd8806_sysfs_ops = {
  .show = lpd8806_attr_show,
  .store = lpd8806_attr_store
};

/*
 * Convenience function for freeing our kobject.
 */
static void lpd8806_release(struct kobject *kobj) {
  struct lpd8806_obj *obj;
  obj = to_lpd8806_obj(kobj);
  kfree(obj);
}

/*
 * This is the show function for our attributes. This will get called
 * whenever one of the sysfs files is read from.
 */
static ssize_t lpd8806_show(struct lpd8806_obj *obj, struct lpd8806_attr *attr, char *buf) {
  if (strcmp(attr->attr.name, "rgb") == 0) {
    return sprintf(buf, "[%hhu %hhu %hhu]\n", obj->grb[0] & 0x7F, obj->grb[1] & 0x7F, obj->grb[2] & 0x7F);
  } else if (strcmp(attr->attr.name, "data") == 0) {
    int i;
    int count;
    for (i = 0; i < STRAND_LEN * 3; i += 3) {
      count = sprintf(buf, "%s%d [%hhu %hhu %hhu]\n", buf, i/3, obj->data[i] & 0x7F, obj->data[i+1] & 0x7F, obj->data[i+2] & 0x7F);  
    }
    return count;
  } else {
    return 0;
  }
}

/*
 * This function will write the entire data array to the strand and then
 * latch it. The interface to the controllers has been reverse
 * engineered so the number of latch bytes is just based on guesswork.
 */
static void update_strand(struct lpd8806_obj *obj) {
  int ret;
  unsigned char latch[] = {0, 0, 0, 0, 0, 0};
  ret = spi_write(device, &obj->data[0], 3 * STRAND_LEN);
  if (ret != 0) {
    printk("LPD8806 Strand Write Failure: %d\n", ret);
  }
  ret = spi_write(device, latch, 6);
  if (ret != 0) {
    printk("LPD8806 Strand Latch Failure: %d\n", ret);
  }
}

/*
 * This is the store function for our attributes. This will get called
 * whenever one of the sysfs files is written to.
 */
static ssize_t lpd8806_store(struct lpd8806_obj *obj, struct lpd8806_attr *attr, const char *buf, size_t count) {
  if (strcmp(attr->attr.name, "rgb") == 0) {
    int i;
    int index = 0;	// Index of LED to change
    unsigned char g, r, b;
    
    // Strand is 7 bit GRB with 1 bit for latch
    printk("lpd8806_store, buf = \"%s\"\n", buf);
    sscanf(buf, "%hhu %hhu %hhu %d", &r, &g, &b, &index);
    printk("rgb=%hhu,%hhu,%hhu, index = %d\n", r, g, b, index);
    obj->grb[0] = g | 0x80;
    obj->grb[1] = r | 0x80;
    obj->grb[2] = b | 0x80;

/*
    // Shift out data
    for (i = 3 * (STRAND_LEN - 1); i > 0; i -= 3) {
      obj->data[i] = obj->data[i-3];
      obj->data[i+1] = obj->data[i-2];
      obj->data[i+2] = obj->data[i-1];
    }
*/

    if(index>=0 && index<STRAND_LEN) {
      obj->data[3*index+0] = obj->grb[0];
      obj->data[3*index+1] = obj->grb[1];
      obj->data[3*index+2] = obj->grb[2];
    }
/*
	If buf has a newline tell update to send the latch signal,
	otherwise it won't
*/
    int display = 0;
    for(i=0; buf[i]; i++) {
      if(buf[i] == '\n') {
	display = 1;
	break;
      }
    }
    printk("display = %d\n", display);
    if(display) {
      update_strand(obj);
    }
    return count;
  } else if (strcmp(attr->attr.name, "data") == 0) {
    int i = 0;
    unsigned char color;
    char *temp;
    char *tok;
    temp = kzalloc(strlen(buf), GFP_KERNEL);
    if (temp) {
      // This implementation is not safe with fprintf buffering
      // TODO: Switch this over to a circular buffer
      strcpy(temp, buf);
      tok = strsep(&temp, " ");      
      while (tok) {
        if (sscanf(tok, "%hhu", &color) == 1) {
          obj->data[i] = color | 0x80;
          i++;
          if (i == 3*STRAND_LEN) {
            break;
          }
        }
        tok = strsep(&temp, " ");
      }
      obj->grb[0] = obj->data[0];
      obj->grb[1] = obj->data[1];
      obj->grb[2] = obj->data[2];
      update_strand(obj);
      kfree(temp);
      return count;
    }
  }
  return 0;
}

/*
 * These structs link the attributes with their files and sysfs
 * functions.
 */
static struct lpd8806_attr grb_attr = __ATTR(rgb, 0666, lpd8806_show, lpd8806_store);
static struct lpd8806_attr data_attr = __ATTR(data, 0666, lpd8806_show, lpd8806_store);

/*
 * This struct stores all of the attributes for our kobject.
 */
static struct attribute *lpd8806_default_attrs[] = {
  &grb_attr.attr,
  &data_attr.attr,
  NULL
};

/*
 * This defines the structure of our kobject.
 */
static struct kobj_type lpd8806_ktype = {
  .sysfs_ops = &lpd8806_sysfs_ops,
  .release = lpd8806_release,
  .default_attrs = lpd8806_default_attrs
};

/*
 * These are used in initialization.
 */
static struct kset *lpd8806_kset;
static struct lpd8806_obj *device_obj;

/*
 * This creates a new kobject and adds it to our kset created in the
 * initialization.
 */
static struct lpd8806_obj *create_lpd8806_obj(const char *name) {
  struct lpd8806_obj *obj;
  int retval;
  int i;
  
  obj = kzalloc(sizeof(*obj), GFP_KERNEL);
  if (!obj) {
    return NULL;
  }
    
  obj->kobj.kset = lpd8806_kset;

  for (i = 0; i < 3; i++) {
    obj->grb[i] = 0;
  }
  
  for (i = 0; i < STRAND_LEN * 3; i++) {
    obj->data[i] = 0x80;
  }
  
  retval = kobject_init_and_add(&obj->kobj, &lpd8806_ktype, NULL, "%s", name);
  if (retval) {
    kobject_put(&obj->kobj);
    return NULL;
  }
  
  kobject_uevent(&obj->kobj, KOBJ_ADD);
  return obj;
}

/*
 * This should call the kobject release function
 */
static void destroy_lpd8806_obj(struct lpd8806_obj *obj) {
  kobject_put(&obj->kobj);
}

/*
 * This is the initialization function for the driver.
 */
static int __init lpd8806_init(void) {
  int status;
  // Again sending out 6 bytes to latch may not be necessary
  unsigned char latch[] = {0, 0, 0, 0, 0, 0};
  struct spi_master *master;
  struct device *temp;
  char buff[20];
  
  lpd8806_kset = kset_create_and_add(DRIVER_NAME, NULL, firmware_kobj);
  if (!lpd8806_kset) {
    kset_unregister(lpd8806_kset);
    printk("LPD8806 Driver Init Failed: %d\n", -ENOMEM);
    return -ENOMEM;
  }
  device_obj = create_lpd8806_obj("device");
  if (!device_obj) {
    destroy_lpd8806_obj(device_obj);
    kset_unregister(lpd8806_kset);
    printk("LPD8806 Driver Init Failed: %d\n", -EINVAL);
    return -EINVAL;
  }
  
  master = spi_busnum_to_master(SPI_BUS_NUM);
  if (!master) {
    destroy_lpd8806_obj(device_obj);
    kset_unregister(lpd8806_kset);
    printk("LPD8806 Driver Init Failed: Bad Master\n");
    return -EINVAL;
  }
  
  device = spi_alloc_device(master);
  if (!device) {
    put_device(&master->dev);
    destroy_lpd8806_obj(device_obj);
    kset_unregister(lpd8806_kset);
    printk("LPD8806 Driver Init Failed: Bad Device\n");
    return -EINVAL;
  }
  
  device->chip_select = SPI_CS;
  snprintf(buff, sizeof(buff), "%s.%u", dev_name(&device->master->dev), device->chip_select);
  
  // Attempt to find the device, and if found hijack it.
  temp = bus_find_device_by_name(device->dev.bus, NULL, buff);
  if (temp) {
    spi_unregister_device(to_spi_device(temp));
    spi_dev_put(to_spi_device(temp));
  }
  
  device->max_speed_hz = SPI_BUS_SPEED;
  device->mode = SPI_MODE_0;
  device->bits_per_word = 8;
  device->irq = -1;
  device->controller_state = NULL;
  device->controller_data = NULL;
  strcpy(device->modalias, DRIVER_NAME);
  
  status = spi_add_device(device);
  
  if (status < 0) {
    spi_dev_put(device);
    put_device(&master->dev);
    destroy_lpd8806_obj(device_obj);
    kset_unregister(lpd8806_kset);
    printk("LPD8806 Driver Init Failed: Add Device Failed\n");
    return status;
  }
  
  spi_write(device, latch, 6);
  
  printk("LPD8806 Driver Added\n");
  
  put_device(&master->dev);
  
  return 0;
}

/*
 * This is the deinitialization function for the driver.
 */
static void __exit lpd8806_exit(void) {
  spi_dev_put(device);
  destroy_lpd8806_obj(device_obj);
  kset_unregister(lpd8806_kset);
  printk("LPD8806 Driver Removed\n");
}

module_init(lpd8806_init);
module_exit(lpd8806_exit);

MODULE_DESCRIPTION("LPD8806 DRIVER");
MODULE_AUTHOR("GREG LARMORE & SEAN RICHARDSON");
MODULE_LICENSE("GPL");
