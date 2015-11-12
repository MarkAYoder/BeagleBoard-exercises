*************************************************
Project 5: Step Motor Driven Light Finder/Tracker
Author: Yue Zhang
*************************************************

This project is about a step motor driven light finder/tracker. There's mainly some practice on gpio manipulation and AD conversion.

Hardware wiring: In this project, I used gpio 30, 31, 48, 5 as outputs to generate step motor controlling signal. A L239 chip is needed to drive the step motor. And I used AIN3 and AIN5 as analog inputs to read the analog value of IR phototransistors. (Note it would be ain4 and ain6 in the program interfacing.)

After correctly wiring up the hardware, I tried to rotate the driver. The motor will rotate by setting the gpio outputs as the sequence shown in hi-torque mode. Then I wrote two functions to make the motor turn clockwise and counter clockwise. Note the sequence is very important since sometimes the motor will turn directly from clockwise to counter clockwise. And it would be the best to turn the motor 2 steps before using it because you don’t know which direction it is in now.

Search/Recording mode: I wrote the code to read the IR phototransistor values while the step motor is turning around. I store them in 2 arrays. Then I added up and averaged every two entries of the arrays that store the left and right light intensity and then find out the smallest average value entry. This would be the direction the motor will turn back to.

Real-time tracking mode: This mode should allow us to rotate back and forth a small degree once a time to track the strongest light source. By comparing the left and right light source intensity, the motor will decide whether to move clockwise or counter-clockwise. Since the IR phototransistors’ values will never be the same, it would be best to set a threshold, below which the motor will stay still.

You can find the demo video on Youtube here:
https://www.youtube.com/watch?v=H8QyIU_3RfE
