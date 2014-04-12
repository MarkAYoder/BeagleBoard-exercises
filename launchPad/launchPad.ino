/*
  Tests connection to a BeagleBone
  Mark A. Yoder
  Waits for input on Serial Port
  g - Green off
  G - Green on
  r - Red off
  R - Red on
*/
char inChar = 0; // incoming serial byte

void setup()
{
  // initialize the digital pin as an output.
  pinMode(RED_LED, OUTPUT);  
  pinMode(GREEN_LED, OUTPUT);  
  // start serial port at 9600 bps:
  Serial.begin(9600);
  Serial.print("Command (R, r, G, g):");
}

void loop()
{
  if(Serial.available() > 0 ) {
    inChar = Serial.read();
    switch(inChar) {
      case 'g':
        digitalWrite(GREEN_LED, LOW);
        Serial.println("Green off");
        break;
      case 'G':
        digitalWrite(GREEN_LED, HIGH);
        Serial.println("Green on");
        break;
      case 'r':
        digitalWrite(RED_LED, LOW);
        Serial.println("Red off");
        break;
      case 'R':
        digitalWrite(RED_LED, HIGH);
        Serial.println("Red on");
        break;
    }
    Serial.print("Command (R, r, G, g):");
  }
}

