---
title: Monitoring Home
date: 2013-11-20
featured_image: "/images/posts/casa-mano.jpg"
author: Tono Riesco
omit_header_text: true
---

### Introduction

The requirements for my monitoring projects are simple:

- **Want to be mostly cabling free.**

One of the things than makes a good monitoring system at home is don't having to make new cabling all around the house each time you put a new sensor or want to check a new temperature room.

- **Want to use open-source products.**

There are several reasons for that. Despite what most people think that we use open-source because is free (like free beer ;-)) in my case is not true. The fact of using open-source products is because the support, the driver availability, the modifications to adapt the product, etc. etc. Several times I did donations to products so at the end, has never be free as a free beer.

### Requirements

- Cheap sensors for temperature, humidity, electrical power consumption, digital status, barometric pressure,
- Long distances > 20 meters
- Cheap controllers.
- Easy deployment
- Mobile, distance and independent data display
- Database for making complex requests if needed

### Hardware

- Sensors: DS18B20 with isolation for the heating system, normal one for standard temperatures, DHT21 for temperature and hygrometers, counters and opto-couplers  for electrical consumption, BMP085 Barometric Pressure,
- Arduino Models: Uno, Mega, Mini Pro, Yún
- Raspberry Pi: Version 2, 512 Model
- Servers: Mac mini Server, Standard Desktop PC, HP Proliant.
- Electronics: 433 Mhz radio transmitters, relays, resistors, diodes, etc.
- Screens and displays: TV, Standard screens, 1.8" TFT LCD Displays, Car Cameras

### Software

- ARM Compilers for Arduino, Raspberry Pi.
- Raspbian
- Debian with LAMP
- Mac OS X with LAMP
- MySQL, SQLite, RRDtools Databases

In the next posts I'll explain all the projects.
