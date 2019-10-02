# From https://github.com/bsteinsbo/DE1-SoC-Sound/issues/7

DTC = dtc
DTCFLAGS = -b 0
dtc_cpp_flags  = -x assembler-with-cpp -nostdinc         \
                 -I /opt/source/dtb-4.19-ti/include      \
                 -undef -D__DTS__

DTCINCLUDES = -i /opt/source/dtb-4.19-ti/include

DTBO := BB-LCD-ADAFRUIT-24-SPI1-00A0.dtbo

all:	$(DTBO)

%.dtbo: %.dts
	cpp $(dtc_cpp_flags) < $< | $(DTC) $(DTCINCLUDES) -I dts -O dtb $(DTCFLAGS) -o $@ -
	
.PHONY:	install
install:
	sudo cp --backup $(DTBO) /lib/firmware
	@echo Add uboot_overlay_addr4=/lib/firmware/$(DTBO) to /boot/uEnv.txt

.PHONY:	clean
clean:
	rm $(DTBO)