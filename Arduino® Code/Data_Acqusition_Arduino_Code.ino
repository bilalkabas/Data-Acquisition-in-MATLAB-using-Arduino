/* THE SUN PANEL CONTROL SYSTEM */
/* SAMET ÖĞÜTEN - BİLAL KABAŞ */

#include <Servo.h>
#include "DHT.h"
#define DHTPIN 9
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

Servo servo;
/** PIN CONFIGURATIONS **/
    // Set LDR pin no
    int LDRPin = 0;         // A0
    // Set DHT pin no
    int DHTPin = 1;         // A1
    // Set SERVO pin no
    int servoPin = 2;       // D2
    // Set BUZZER pin no
    int buzzerPin = 8;      // D8
/** PROGRAM VARIABLES **/
    int samplingRate = 150;
    int toneSwap = 1;
/** LIGHT CONFIGURATIONS **/
    #define powerLED 7
    #define lightLED 10
    #define panelOpenLED 11
    #define panelMovingLED 12

void setup() {
    Serial.begin(9600);
    pinMode(13, OUTPUT);
    // Power status LED
    pinMode(powerLED, OUTPUT);
    // Light status LED
    pinMode(lightLED, OUTPUT);
    // Panels are open
    pinMode(panelOpenLED, OUTPUT);
    // Panels are moving
    pinMode(panelMovingLED, OUTPUT);
    // Connect to the servo
    servo.attach(servoPin);
    // Initial position of the servo
    servo.write(0);
    // Connect to the DHT
    dht.begin();
}

void loop() {
    if (Serial.available() > 0) {
        // Get the message from MATLAB
        int message = Serial.read();

        /** CONFIGURATIONS **/
            if (message == 0) {
                delay(50);
                samplingRate = Serial.read();
            }
            // Turn on the power status LED
            if (message == 31) {
                digitalWrite(powerLED, 1);
            }


        /** AUTOMATIC CONTROL **/
            if (message == 1) {
                while (1) {
                    delay(samplingRate);
                    // Send the LDR value
                    Serial.println(analogRead(LDRPin));
                    // Send the Temp value
                    Serial.println(dht.readTemperature());
                    // Listen for the command
                    if (Serial.available() > 0) {
                        message = Serial.read();
                        
                        // Close the panels -- No light
                        if (message == 100) {
                            digitalWrite(panelMovingLED, 1);
                            for (int i = 90; i >= 0; i--) {
                                if (i % 18 == 0) {
                                    if (toneSwap == 1) {
                                        tone(buzzerPin, 450, 400);
                                        toneSwap = 0;
                                    }
                                    else {
                                        tone(buzzerPin, 300, 400);
                                        toneSwap = 1;
                                    }
                                }
                                servo.write(i);
                                delay(75);
                            }
                            digitalWrite(panelMovingLED, 0);
                            digitalWrite(panelOpenLED, 0);
                        }

                        // Open the panels => 90 degree
                        if (message == 101) {
                            digitalWrite(panelMovingLED, 1);
                            for (int i = 0; i <= 90; i++) {
                                if (i % 18 == 0) {
                                    if (toneSwap == 1) {
                                        tone(buzzerPin, 300, 400);
                                        toneSwap = 0;
                                    }
                                    else {
                                        tone(buzzerPin, 450, 400);
                                        toneSwap = 1;
                                    }
                                }
                                servo.write(i);
                                delay(75);
                            }
                            digitalWrite(panelMovingLED, 0);
                            digitalWrite(panelOpenLED, 1);
                        }
                        // Close the panels -- Too hot
                        if (message == 102) {
                            digitalWrite(panelMovingLED, 1);
                            for (int i = 90; i >= 0; i--) {
                                if (i % 18 == 0) {
                                    if (toneSwap == 1) {
                                        tone(buzzerPin, 450, 400);
                                        toneSwap = 0;
                                    }
                                    else {
                                        tone(buzzerPin, 300, 400);
                                        toneSwap = 1;
                                    }
                                }
                                servo.write(i);
                                delay(75);
                            }
                            digitalWrite(panelMovingLED, 0);
                            digitalWrite(panelOpenLED, 0);
                        }

                        // Turn off the status light LED
                        if (message == 103) {
                            digitalWrite(lightLED, 0);
                        }

                        // Turn on the status light LED
                        if (message == 104) {
                            digitalWrite(lightLED, 1);
                        }
                    }
                }
            }


        /** MONITOR SENSOR DATA **/
            if (message == 2) {
                while (1) {
                    delay(samplingRate);
                    // Send the LDR value
                    Serial.println(analogRead(LDRPin));
                    // Send the Temp value
                    Serial.println(dht.readTemperature());
                }
            }
            

        /** TEST & DEBUGGING **/
            // Turn on the built-in LED
            if (message == 10)
                digitalWrite(13, HIGH);

            // Turn off the built-in LED
            if (message == 11)
                digitalWrite(13, LOW);

            // Test the analog pins
            if (message == 12) {
                delay(50);
                int analogPinNo = Serial.read();
                while (1) {
                    delay(100);
                    Serial.println(analogRead(analogPinNo));
                }
            }
            // Test the servo
            if (message == 13) {
                delay(10);
                int servoPosition = Serial.read();
                servo.write(servoPosition);
            }
            // Test the buzzer
            if (message == 14) {
                tone(buzzerPin, 300, 1000);
            }
            // Turn on the light status LED
            if (message == 15) {
                digitalWrite(lightLED, 1);
            }
            // Turn off the light status LED
            if (message == 16) {
                digitalWrite(lightLED, 0);
            }
            // Turn on the panels open LED
            if (message == 17) {
                digitalWrite(panelOpenLED, 1);
            }
            // Turn off the panels open LED
            if (message == 18) {
                digitalWrite(panelOpenLED, 0);
            }
            // Turn on the panels moving LED
            if (message == 19) {
                digitalWrite(panelMovingLED, 1);
            }
            // Turn off the panels moving LED
            if (message == 20) {
                digitalWrite(panelMovingLED, 0);
            }

    }
}