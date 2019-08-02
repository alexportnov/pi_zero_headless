# RaspberryPI Zero - Headless images
The purpose is to create a headless (a.k.a without display or direct user input) set of images to be flushed on RaspberryPI Zero/ZeroW. Image is always based on latest [Raspbian Lite](https://www.raspberrypi.org/downloads/raspbian/) and [Kernel](https://github.com/raspberrypi/linux).

NOTE: This project supports RaspberryPI Zero/ZeroW only. While other variants can be supported with minimal modifications see the "Why RaspberryPI Zero?" section below.

## What is it good for?
There are multiple use-cases where the display or direct user input is simply not needed.
Consider a drone, RC car, web-server, webcam controller based on Raspberry board. Once you have your code set and running you will never need any non console/network/sensor/button based interaction with the board.

## Why?
1) The out of the box images pretty much forces you to connect a HDMI display and USB hub with keyboard even if you want to simply SSH/UART to the board and run a terminal application.
Sure, you can edit the images, connect it to the network (on Zero W), install Bonjour or connect UART pins to serial to USB converter ...
This image allows you to simply connect a USB to computer (with microUSB cable) and get a serial interface - that's it; you are ready to go.

2) Having display/input interfaces (even if they are not connected) consumes power, makes the images larger, boot time slower. No point of having those if you are not using them.

## Why RaspberryPI Zero?
* On one end we have the micro-controller like Arduino (great power consumption, no computation power).
* On the other stronger and bigger boards like the new RaspberryPi 4, ODROID-XU4, etc.
* RaspberryPI Zero in somewhere in the middle. It provides a standard Linux (with all its advantages) combined with moderate power consumption.
Out of the box you can connect a camera (MIPI or USB), WiFi, BT do some image processing while still controlling your servos using the GPIOs. You can't do the first on micro-controller.
We mentioned servos ... well, it implies that we run on battery powered device - having reasonable power consumption is crucial.
While RaspberryPi4 provides 10x times the performance, it also consumes 9 times the battery power. The board is bigger and more expensive. You actually have to use a heat sink to continuously run it.

Nice performance/power comparison on all Raspberry models can be found [HERE](https://www.tomshardware.com/reviews/raspberry-pi-4-b,6193.html)


## How?
We basically create scripts and patch sets over the Raspbian Lite and its Kernel. Those compile and create a single, flushable *.img file you can use out of the box.


There are 4 scripts:
  1) Init - install all packages needed for the process, fetch the toolchain, sources and images. Probably needs to run once.
  2) Build - compile everything needed
  3) Images - re/package everyting back into IMG file
  4) Clean - remove temp files and folders


* Some commands requier root (sudo) - this is due to mounting the original image files and making the modifications or installing the apt-get packages.

```sh
sudo ./init.sh
./build.sh
sudo ./images.sh
```

You have ./out/raspbian_lite_headless.img file ready to be flushed on the SDCARD using the software of your choice.
Example for sdcard reader detected as /dev/sdb
```sh
sudo umount /dev/sdb*
sudo dd bs=4M status=progress if=./out/raspbian_headless.img of=/dev/sdb
sudo umount /dev/sdb*
```

Connect usign microUSB cable - the board will boot and you an connect to using COMX port on windows or /dev/ttyUSBX on Linux - right into login prom.
Login detais as in standard image pi:raspberry
First boot may take a while - you get the prom only after init is fully done.

* Tested on Ubuntu18.04LTS but it probably works similar on other systems capable of building Linux kernel.
I wouldn't try it on Cygwin tho ... You can always setup a VM.
* Why using scripts and patches?
  1) This way it the easiest to keep up-to-date with latest Raspbian releases.
  2) We don't need to distribute binaries.
  3) You can choose the patches you actually want to use.

## Power
Stock BusterLite (2019-07-10) consumes 144mW on idle (not bad ...)

## Boot Time
Stock BusterLite (2019-07-10) boot time (not first) is TODO


## TODO
Current commit will get you image file with headless setup.
Next step is starting the power/size optimizations for headless case.


Have fun!
