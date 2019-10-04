# Data Acquisition in MATLAB® using Arduino® UNO

[![license](https://img.shields.io/badge/MATLAB-R2019b-orange)](https://ch.mathworks.com/products/new_products/latest_features.html)
![90+% MATLAB](https://img.shields.io/badge/MATLAB-88.2%25-blue)
[![license](https://img.shields.io/badge/License-MIT-green)](https://github.com/bilalkabas/Data-Acquisition-in-MATLAB-using-Arduino/blob/master/LICENSE)

This project aims to acquire sensor data through the Arduino in MATLAB. Considering the data, the MATLAB code will basically control an actuator through the Arduino.

A photoresistor and temperature sensor will be used to measure the amount of light and the temperature in Celcius. The data coming from the sensors will be monitored in real time. According to the measurements and the tresholds that can be set in the user interface, a servo motor representing a sun panel will be opened or closed. Also, four LEDs each representing a different status will be controlled.
<br><br>
## Components
 
-   Arduino® UNO
-   LDR (Photoresistor)
-   DHT11 (Temperature & Humidity Sensor)
-   SG90 Servo Motor
-   Buzzer
-   LED x4
<br><br>
## Libraries
-   **Servo Built-in by Michael Margolis** - No need to install, this is built-in.
-   **DHT Sensor Library by Adafruit version 1.3.7** - Must be installed.

    If you do not know how to install an Arduino® library, visit [this page](https://www.arduino.cc/en/guide/libraries).
<br><br>
## Get Ready to Run
-    **STEP 1: Upload the Sketch to the Arduino®**

      Inside the [Arduino® Code](https://github.com/bilalkabas/Data-Acquisition-in-MATLAB-using-Arduino/tree/master/Arduino%C2%AE%20Code) folder, the [Data_Acqusition_Arduino_Code.ino](https://github.com/bilalkabas/Data-Acquisition-in-MATLAB-using-Arduino/blob/master/Arduino%C2%AE%20Code/Data_Acqusition_Arduino_Code.ino) file must be uploaded to the Arduino® UNO. Arduino® IDE or other compatible IDEs can be used.
      
-    **STEP 2: Build the Circuit**
      
      Connect the DHT11 to VCC and GND pins properly and connect the data pin to the D9 pin on the Arduino®. Connect the LDR to the A0 pin. Connect the servo motor to VCC and GND properly and connect the data pin to the D2 pin. Connect the buzzer to VCC and GND and connect the data pin to the D8 pin. The LEDs are all connected to pull-down resistors and D7, D10, D11 and D12 pins on the Arduino®.
      
-    **STEP 3: Run the MATLAB Code**
      
      Inside the [MATLAB® Code](https://github.com/bilalkabas/Data-Acquisition-in-MATLAB-using-Arduino/tree/master/MATLAB%C2%AE%20Code) folder, the [Data_Acquisition_MATLAB_Code.m](https://github.com/bilalkabas/Data-Acquisition-in-MATLAB-using-Arduino/tree/master/MATLAB%C2%AE%20Code) file will be opened with MATLAB®. When the code is run in MATLAB®, an **UI Figure** will appear which is the software part of the project.
<br><br>
## User Interface

The user interface to interact with the Arduino® has been built in the App Designer in MATLAB® R2019b.
<br><br>
**MODE 1: Automatic Control**

Turn on the system using On/Off button on the right panel and wait till the red status indicator turns to the green. To activate the automatic control mode, click the second switch. Now, the tresholds for both the light intensity and temperature can be set manually. According to the treshold values, the servo motor will be opened or closed.
<br><br>
![Automatic Control Tab](https://github.com/bilalkabas/Data-Acquisition-in-MATLAB-using-Arduino/blob/master/docs/images/Data-Acquisition-in-MATLAB-using-Arduino_UI1.png)
<br><br><br>
**MODE 2: Monitor Sensor Data**

Turn on the system using On/Off button on the right panel and wait till the red status indicator turns to the green. To monitor the sensor data, click the monitor sensor data tab and click the third switch.
<br><br>
![Monitor Sensor Data](https://github.com/bilalkabas/Data-Acquisition-in-MATLAB-using-Arduino/blob/master/docs/images/Data-Acquisition-in-MATLAB-using-Arduino_UI2.png)
<br><br><br>
**Test & Debug Tab**

Turn on the system using On/Off button on the right panel and wait till the red status indicator turns to the green. Click the Test & Debug tab. The servo motor, buzzer, LEDs and the built-in LED can be controlled here. Also, the data coming from the analog pins of Arduino® can be monitored in real time. These functionalities are helpful to check if the Arduino®, sensors and servo motor are connected and working properly.
<br><br>
![Test & Debug](https://github.com/bilalkabas/Data-Acquisition-in-MATLAB-using-Arduino/blob/master/docs/images/Data-Acquisition-in-MATLAB-using-Arduino_UI3.png)
<br><br><br>
## Contribution

[Bilal KABAŞ](https://github.com/bilalkabas/)

Samet ÖĞÜTEN
