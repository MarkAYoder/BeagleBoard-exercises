#ifndef cfaf128128b_0145t_h
#define cfaf128128b_0145t_h

void init_tft(int deviceNum);
int SPI3W_sendCommand(char cmd);
int SPI3W_sendData(char data);
void tft_writeColor(char r,char g,char b);
void setOrientation(int orientation);

#endif
