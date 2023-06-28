// SPDX-License-Identifier: GPL-2.0-only
/*
 * Digital temperature sensor 
 * Copyright (c) 2021 Puranjay Mohan <puranjay12@gmail.com>
 * Converted from TMP117 to as621 by Mark A. Yoder <yoder@rose-hulman.edu>
 *
 * Driver for the AMS as621  Temperature Sensor
 * (7-bit I2C slave address (0x48))
 *
 */

#include <linux/err.h>
#include <linux/i2c.h>
#include <linux/module.h>
#include <linux/bitops.h>
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/limits.h>
#include <linux/property.h>

#include <linux/iio/iio.h>

#define AS621_REG_TEMP			0x0
#define AS621_REG_CFGR			0x1
#define AS621_REG_LOW_LIM		0x2
#define AS621_REG_HIGH_LIM		0x3
#define AS621_REG_DEVICE_ID	0x4		// Doesn't have one.

#define AS621_RESOLUTION_10UC	78125
#define MICRODEGREE_PER_10MILLIDEGREE	10000

#define AS621_DEVICE_ID		0x00	// Doesn't have one.

struct as621_data {
	struct i2c_client *client;
};

static int as621_read_raw(struct iio_dev *indio_dev,
			   struct iio_chan_spec const *channel, int *val,
			   int *val2, long mask)
{
	struct as621_data *data = iio_priv(indio_dev);
	s32 ret;

	switch (mask) {
	case IIO_CHAN_INFO_RAW:
		ret = i2c_smbus_read_word_swapped(data->client,
						  AS621_REG_TEMP);
		if (ret < 0)
			return ret;
		*val = sign_extend32(ret, 15);
		return IIO_VAL_INT;

	case IIO_CHAN_INFO_PROCESSED:
		ret = i2c_smbus_read_word_swapped(data->client,
						  AS621_REG_TEMP);
		if (ret < 0)
			return ret;
		*val   = (sign_extend32(ret, 15) * AS621_RESOLUTION_10UC / MICRODEGREE_PER_10MILLIDEGREE);
		return IIO_VAL_INT;

	case IIO_CHAN_INFO_SCALE:
		/*
		 * Conversion from 10s of uC to mC
		 * as IIO reports temperature in mC
		 */
		*val = AS621_RESOLUTION_10UC / MICRODEGREE_PER_10MILLIDEGREE;
		*val2 = (AS621_RESOLUTION_10UC %
					MICRODEGREE_PER_10MILLIDEGREE) * 100;

		return IIO_VAL_INT_PLUS_MICRO;

	default:
		return -EINVAL;
	}
}

static int as621_write_raw(struct iio_dev *indio_dev, struct iio_chan_spec
			    const *channel, int val, int val2, long mask)
{
	switch (mask) {
	default:
		return -EINVAL;
	}
}

static const struct iio_chan_spec as621_channels[] = {
	{
		.type = IIO_TEMP,
		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
				      BIT(IIO_CHAN_INFO_PROCESSED) |
				      BIT(IIO_CHAN_INFO_SCALE),
	},
};

static const struct iio_info as621_info = {
	.read_raw = as621_read_raw,
	.write_raw = as621_write_raw,
};

static int as621_identify(struct i2c_client *client)
{
	// const struct i2c_device_id *id;
	unsigned long match_data;
	int dev_id;

	dev_id = i2c_smbus_read_word_swapped(client, AS621_REG_DEVICE_ID);
	if (dev_id < 0)
		return dev_id;

	dev_info(&client->dev, "as621_identify id (0x%x)\n", dev_id);

	switch (dev_id) {
	case AS621_DEVICE_ID:
		return dev_id;
	}

	dev_info(&client->dev, "Unknown device id (0x%x), use fallback compatible\n",
		 dev_id);

	match_data = (uintptr_t)device_get_match_data(&client->dev);
	if (match_data)
		return match_data;

	// id = i2c_client_get_device_id(client);
	// if (id)
	// 	return id->driver_data;

	dev_err(&client->dev, "Failed to identify unsupported device\n");

	return -ENODEV;
}

static int as621_probe(struct i2c_client *client)
{
	struct as621_data *data;
	struct iio_dev *indio_dev;
	int ret, dev_id;
	
	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
		return -EOPNOTSUPP;

	ret = as621_identify(client);
	if (ret < 0)
		return ret;

	dev_id = ret;

	dev_info(&client->dev, "as621_probe id (0x%x)\n", dev_id);

	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
	if (!indio_dev)
		return -ENOMEM;

	data = iio_priv(indio_dev);
	data->client = client;

	indio_dev->modes = INDIO_DIRECT_MODE;
	indio_dev->info = &as621_info;

	switch (dev_id) {
	case AS621_DEVICE_ID:
		indio_dev->channels = as621_channels;
		indio_dev->num_channels = ARRAY_SIZE(as621_channels);
		indio_dev->name = "as621";
		break;
	}

	return devm_iio_device_register(&client->dev, indio_dev);
}

static const struct of_device_id as621_of_match[] = {
	{ .compatible = "ti,as621", .data = (void *)AS621_DEVICE_ID },
	{ }
};
MODULE_DEVICE_TABLE(of, as621_of_match);

static const struct i2c_device_id as621_id[] = {
	{ "as621", AS621_DEVICE_ID },
	{ }
};
MODULE_DEVICE_TABLE(i2c, as621_id);

static struct i2c_driver as621_driver = {
	.driver = {
		.name	= "as621",
		.of_match_table = as621_of_match,
	},
	.probe_new	= as621_probe,
	.id_table	= as621_id,
};
module_i2c_driver(as621_driver);

MODULE_AUTHOR("Mark A. Yoder <Mark.A.Yoder@Rose-Hulman.edu>");
MODULE_DESCRIPTION("AMS AS621 Temperature sensor driver");
MODULE_LICENSE("GPL");
