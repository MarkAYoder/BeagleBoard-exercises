CC=gcc
CCPP=g++

RES_DIR= ../Adafruit-GFX-Library/

TARGETS=Adafruit_LEDBackpack \
Adafruit_LEDBackpack.opp \
$(RES_DIR)/Adafruit_GFX.opp \
$(RES_DIR)/glcdfont.o

all: $(TARGETS)

clean: 
	clear
	rm -f $(TARGETS)

Adafruit_LEDBackpack: Adafruit_LEDBackpack.opp $(RES_DIR)/Adafruit_GFX.opp $(RES_DIR)/glcdfont.o
	$(CCPP) $^ -o $@

%.o: %.c
	$(CC) -c $< -o $@

%.opp: %.cpp
	$(CCPP) -c $< -o $@


