// SPDX-License-Identifier: GPL-2.0-only
/*
 * Digital temperature sensor
 * Copyright (c) 2021 Puranjay Mohan <puranjay12@gmail.com>
 * Converted from TMP117 to STTS22H by Mark A. Yoder <Mark.A.Yoder@Rose-Hulman.edu>
 *
 * Driver for the ST STTS22H Temperature Sensor
 * (7-bit I2C slave address (0x4B))
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

#define STTS22H_REG_DEVICE_ID	0x1
#define STTS22H_REG_HIGH_LIM	0x2
#define STTS22H_REG_LOW_LIM		0x3
#define STTS22H_REG_CFGR		0x4
#define STTS22H_REG_STATUS		0x5
#define STTS22H_REG_TEMP_L		0x6
#define STTS22H_REG_TEMP_H		0x7

#define STTS22H_REG_FREERUN		0x34	// Freerun and 200 Hz ODR
#define STTS22H_DEVICE_ID		0xA0

#define MICRODEGREE_PER_10MILLIDEGREE	10000

struct stts22h_data {
	struct i2c_client *client;
};

static int stts22h_read_raw(struct iio_dev *indio_dev,
			   struct iio_chan_spec const *channel, int *val,
			   int *val2, long mask)
{
	struct stts22h_data *data = iio_priv(indio_dev);
	s32 hi;		// Upper byte of temp
	s32 lo;

	switch (mask) {
	case IIO_CHAN_INFO_PROCESSED:
		hi = i2c_smbus_read_byte_data(data->client, STTS22H_REG_TEMP_H);
		if (hi < 0)
			return hi;
		lo = i2c_smbus_read_byte_data(data->client, STTS22H_REG_TEMP_L);
		if (lo < 0)
			return lo;

		*val = sign_extend32(hi<<8 | lo, 15);
		return IIO_VAL_INT;

	case IIO_CHAN_INFO_SCALE:
		/*
		 * Conversion from 10s of uC to mC
		 * as IIO reports temperature in mC
		 */
		*val = 0;
		*val2 = MICRODEGREE_PER_10MILLIDEGREE;

		return IIO_VAL_INT_PLUS_MICRO;

	default:
		return -EINVAL;
	}
}

static int stts22h_write_raw(struct iio_dev *indio_dev, struct iio_chan_spec
			    const *channel, int val, int val2, long mask)
{
	switch (mask) {
	default:
		return -EINVAL;
	}
}

static const struct iio_chan_spec stts22h_channels[] = {
	{
		.type = IIO_TEMP,
		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED) |
				      BIT(IIO_CHAN_INFO_SCALE),
	},
};

static const struct iio_info stts22h_info = {
	.read_raw = stts22h_read_raw,
	.write_raw = stts22h_write_raw,
};

static int stts22h_identify(struct i2c_client *client)
{
	// const struct i2c_device_id *id;
	unsigned long match_data;
	int dev_id;

	dev_id = i2c_smbus_read_byte_data(client, STTS22H_REG_DEVICE_ID);
	if (dev_id < 0)
		return dev_id;

	dev_info(&client->dev, "stts22h_identify id (0x%x)\n", dev_id);

	switch (dev_id) {
	case STTS22H_DEVICE_ID:
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

static int stts22h_probe(struct i2c_client *client)
{
	struct stts22h_data *data;
	struct iio_dev *indio_dev;
	int ret, dev_id;
	
	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
		return -EOPNOTSUPP;

	ret = stts22h_identify(client);
	if (ret < 0)
		return ret;

	dev_id = ret;

	dev_info(&client->dev, "stts22h_probe id (0x%x)\n", dev_id);

	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
	if (!indio_dev)
		return -ENOMEM;

	data = iio_priv(indio_dev);
	data->client = client;

	indio_dev->modes = INDIO_DIRECT_MODE;
	indio_dev->info = &stts22h_info;

	switch (dev_id) {
	case STTS22H_DEVICE_ID:
		indio_dev->channels = stts22h_channels;
		indio_dev->num_channels = ARRAY_SIZE(stts22h_channels);
		indio_dev->name = "stts22h";
		break;
	}
	// Enable temperture reading
	ret = i2c_smbus_write_byte_data(data->client,
						STTS22H_REG_CFGR, STTS22H_REG_FREERUN);
	if(ret < 0)
		return ret;

	return devm_iio_device_register(&client->dev, indio_dev);
}

static const struct of_device_id stts22h_of_match[] = {
	{ .compatible = "st,stts22h", .data = (void *)STTS22H_DEVICE_ID },
	{ }
};
MODULE_DEVICE_TABLE(of, stts22h_of_match);

static const struct i2c_device_id stts22h_id[] = {
	{ "stts22h", STTS22H_DEVICE_ID },
	{ }
};
MODULE_DEVICE_TABLE(i2c, stts22h_id);

static struct i2c_driver stts22h_driver = {
	.driver = {
		.name	= "stts22h",
		.of_match_table = stts22h_of_match,
	},
	.probe_new	= stts22h_probe,
	.id_table	= stts22h_id,
};
module_i2c_driver(stts22h_driver);

MODULE_AUTHOR("Mark A. Yoder <Mark.A.Yoder@Rose-Hulman.edu>");
MODULE_DESCRIPTION("ST stts22h Temperature sensor driver");
MODULE_LICENSE("GPL");
