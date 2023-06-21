#include <linux/module.h>
#define INCLUDE_VERMAGIC
#include <linux/build-salt.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

BUILD_SALT;

MODULE_INFO(vermagic, VERMAGIC_STRING);
MODULE_INFO(name, KBUILD_MODNAME);

__visible struct module __this_module
__section(".gnu.linkonce.this_module") = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

#ifdef CONFIG_RETPOLINE
MODULE_INFO(retpoline, "Y");
#endif

static const struct modversion_info ____versions[]
__used __section("__versions") = {
	{ 0xd00fedb8, "module_layout" },
	{ 0xb0732499, "i2c_del_driver" },
	{ 0xc9c51a3d, "i2c_register_driver" },
	{ 0x7517a6b, "_dev_err" },
	{ 0x1ff2875c, "device_get_match_data" },
	{ 0x3e905bde, "_dev_info" },
	{ 0xbf669bdc, "__devm_iio_device_register" },
	{ 0xa764f2c6, "devm_iio_device_alloc" },
	{ 0x530ea636, "i2c_smbus_read_word_data" },
	{ 0x9d0f2bda, "i2c_smbus_write_word_data" },
};

MODULE_INFO(depends, "");

MODULE_ALIAS("i2c:tmp116");
MODULE_ALIAS("i2c:tmp117");
MODULE_ALIAS("of:N*T*Cti,tmp116");
MODULE_ALIAS("of:N*T*Cti,tmp116C*");
MODULE_ALIAS("of:N*T*Cti,tmp117");
MODULE_ALIAS("of:N*T*Cti,tmp117C*");
