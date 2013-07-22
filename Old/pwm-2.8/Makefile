#   ----------------------------------------------------------------------------
#   Name of the ARM GCC cross compiler & archiver
#   ----------------------------------------------------------------------------
ARM_TOOLCHAIN_PREFIX  ?= arm-none-linux-gnueabi-
ifdef ARM_TOOLCHAIN_PATH
ARM_CC := $(ARM_TOOLCHAIN_PATH)/bin/$(ARM_TOOLCHAIN_PREFIX)gcc
ARM_AR := $(ARM_TOOLCHAIN_PATH)/bin/$(ARM_TOOLCHAIN_PREFIX)ar
else
ARM_CC := gcc
ARM_AR := ar
endif

# Get any compiler flags from the environmentre
ARM_CFLAGS = $(CFLAGS)
ARM_CFLAGS += -std=gnu99 \
-Wdeclaration-after-statement -Wall -Wno-trigraphs \
-fno-strict-aliasing -fno-common -fno-omit-frame-pointer \
-D_DEBUG_ \
-c -O3
ARM_LDFLAGS = $(LDFLAGS)
ARM_LDFLAGS+=-lglib-2.0 
CINCLUDES=-I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include

#   ----------------------------------------------------------------------------
#   List of source files
#   ----------------------------------------------------------------------------
OBJs := dm3730-pwm-demo.o  dm3730-pwm.o

#   ----------------------------------------------------------------------------
#   Makefile targets
#   ----------------------------------------------------------------------------
.PHONY : clean

all: gpp_exec
clean: gpp_clean


gpp_exec: $(OBJs)
	$(ARM_CC) $(ARM_LDFLAGS) $(CINCLUDES) $(OBJs) -o pwm-demo

%.o : %.c
	$(ARM_CC) $(ARM_CFLAGS) $(CINCLUDES) -o $@ $<

gpp_clean:
	@rm -Rf *.o pwm-demo

