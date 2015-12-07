#include "HT1632.h"

#define DATA 2
#define WR   3
#define CS   4
#define CS2  5

// use this line for single matrix
HT1632LEDMatrix matrix = HT1632LEDMatrix(DATA, WR, CS);
// use this line for two matrices!
//HT1632LEDMatrix matrix = HT1632LEDMatrix(DATA, WR, CS, CS2);

void setup() {
  Serial.begin(9600);
  matrix.begin(HT1632_COMMON_16NMOS);  
  matrix.fillScreen();
  delay(500);

}

void loop() {
  matrix.clearScreen(); 
   // draw a pixel!
  matrix.drawPixel(0, 0, 1);
  matrix.writeScreen();
  
  delay(500);
   // clear a pixel!
  matrix.drawPixel(0, 0, 0); 
  matrix.writeScreen();
  
  // draw a big rect on the screen
  matrix.fillRect(matrix.width()/4, matrix.height()/4, 
                  matrix.width()/2, matrix.height()/2, 1);
  matrix.writeScreen();
  delay(500);

  // draw an outline
  matrix.drawRect(0, 0, matrix.width(), matrix.height(), 1);
  matrix.writeScreen();
  delay(500);
  
  // draw an 'X' in red
  matrix.clearScreen(); 
  matrix.drawLine(0, 0, matrix.width()-1, matrix.height()-1, 1);
  matrix.drawLine(matrix.width()-1, 0, 0, matrix.height()-1, 1);
  matrix.writeScreen();
  delay(500);

  // fill a circle
  matrix.fillCircle(matrix.width()/2-1, matrix.height()/2-1, 7, 1);
  matrix.writeScreen();
  delay(500);

  // draw an inverted circle
  matrix.drawCircle(matrix.width()/2-1, matrix.height()/2-1, 4, 0);
  matrix.writeScreen();
  delay(500);
  
  matrix.clearScreen(); 
  // draw some text!
  matrix.setTextSize(1);    // size 1 == 8 pixels high
  matrix.setTextColor(1);   // 'lit' LEDs

  if (matrix.width() <= 24) {
    matrix.setCursor(0, 0);   // start at top left, with one pixel of spacing
    matrix.print("Adaf ");
    matrix.setCursor(0, 8);   // next line, 8 pixels down
    matrix.print("ruit");
    matrix.writeScreen();
  } else if (matrix.width() > 24) {
    matrix.setCursor(0, 0);   // start at top left, with one pixel of spacing
    matrix.print("Adafruit");
    matrix.setCursor(0, 8);   // next line, 8 pixels down
    matrix.print("Industr.");
    matrix.writeScreen();
 }
  
  delay(2000);

  // whew!
}
