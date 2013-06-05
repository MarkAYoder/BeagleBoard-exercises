CC=gcc
CCPP=g++

RES_DIR= Resources

TARGETS=matrix16x26 \
main.opp \
$(RES_DIR)/MMAP/mmapgpio.opp \
$(RES_DIR)/adafruit/HT1632/HT1632.opp \
$(RES_DIR)/adafruit/HT1632/glcdfont.o

all: $(TARGETS)

clean: 
	clear
	rm -f $(TARGETS)

matrix16x26: main.opp $(RES_DIR)/MMAP/mmapgpio.opp $(RES_DIR)/adafruit/HT1632/HT1632.opp $(RES_DIR)/adafruit/HT1632/glcdfont.o
	$(CCPP) $^ -o $@

main.opp: $(RES_DIR)/adafruit/HT1632/HT1632.opp
$(RES_DIR)/HT1632.opp: $(RES_DIR)/MMAP/mmapgpio.opp $(RES_DIR)/adafruit/HT1632/glcdfont.o

%.o: %.c
	$(CC) -c $< -o $@

%.opp: %.cpp
	$(CCPP) -c $< -o $@


