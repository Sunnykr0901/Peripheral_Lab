Group 6 Assignment 6 README:

Aim: 1) Use an ADC to convert an analog input voltage to its digital equivalent and then display it on the LED display of the kit. Control the speed a stepper motor by changing this analog voltage. 
     2) Mount a pointer and a calibrated paper dial across the shaft of thestepper motor. The pointer should point to the voltage (on the dial) corresponding to that of the input to the ADC.
Extra:  - Voltage Graph
 	
Group members:
a) Devansh Gupta 
b) Aviral Gupta
c) Rishi Pathak
d) Sunny Kumar


Steps to Load Files on 8085:
a) Download files and place in same folder as "xt85" application and setup the 8085 board
b) Assembly: Pre-assembled .hex and .lst files provided
c) Open the "xt85" application with 8085 board in "Serial" mode (4th switch to the right)
d) Press Ctrl+D twice, enter file name and transfer file to 8085 board
e) Change 4th switch on 8085 board back to the left



Running the Program:
1) Go to location 9000H and press execute.
2) Question 1: Change the input voltage in the function generator and the motor will rotate according to the voltage. Higher the voltage, Higher the Speed.( Do not give more than 3.4V input )
   Question 2: Change the input voltage and the Stepper Motor will rotate to the input voltage on the paperdial. Maximum supported value is around 3.4V.