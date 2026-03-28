[FreeBSD](https://linuxhint.com/category/freebsd/)

# How to check CPU temperature in FreeBSD

This is going to be a short post that’ll explain to FreeBSD users how to check their CPU temperature. We’ll assume that most of you are using an Intel or AMD processor and are comfortable with using the FreeBSD command line option.

## Before we start

We’ll list a few different methods for checking CPU temperature in FreeBSD, and in each, we’ll use the command line option. Whichever command line you choose to check CPU the temperature, you’ll be activating the driver for the coretemp device if you’re using an Intel processor CPU or the amdtemp device driver if you’re using AMD. This is for detecting the digital thermal sensoring.

Open the /boot/loader.conf file to launch the coretemp/amdtemp driver as a module upon boot, and see the CPU temperature.

## Check CPU temperature on FreeBSD

Issue the following command into the terminal, and the system will show you the CPU temperature:

$ sysctl -a | grep temperature

You can also type the following to check the CPU temperature:

$ sysctl dev.cpu | grep temperature

![](https://linuxhint.com/wp-content/uploads/2020/12/check-CPU-temperature-FreeBSD_1.jpg)

## Launch the temp driver upon boot

The coretemp driver issues the CPU temperature for Intel processors. To load the coretemp driver upon boot, type in the following command:

$ nano /boot/loader.conf

Add the following if you’re using an Intel CPUs:

# coretemp_load="YES"

And if you’re using an AMD CPU, add:

# amdtemp_load="YES"

![](https://linuxhint.com/wp-content/uploads/2020/12/check-CPU-temperature-FreeBSD_2.jpg)  
To apply changes, save the file and exit.

You can also load the driver without restarting. Use the command below if you’re using Intel:

$ kldload coretemp

![](https://linuxhint.com/wp-content/uploads/2020/12/check-CPU-temperature-FreeBSD_3.jpg)  
And if you’re using AMD, type:

$ kldload amdtemp

To check if the drivers have been loaded, type:

$ dmesg | tail -10

![](https://linuxhint.com/wp-content/uploads/2020/12/check-CPU-temperature-FreeBSD_4.jpg)  
Now check the CPU temperature with the command below:

$ sysctl -a | grep -i temperature

![](https://linuxhint.com/wp-content/uploads/2020/12/check-CPU-temperature-FreeBSD_5.jpg)  
Lastly, you can view more details with the ipmitool, and abbreviation for Intelligent Platform Management Interface. It’s a command-line that’ll fill you in on the temperature details.

$ ipmitool

![](https://linuxhint.com/wp-content/uploads/2020/12/check-CPU-temperature-FreeBSD_6.jpg)

## In summary

This tutorial has shown you how to check CPU temperature on FreeBSD. The CPU temperature for both AMD and Intel processors can be checked with the sysctl command. The driver that’s responsible for maintaining temperature reports on Intel is tempcore, whereas AMD processors use the tempcore driver. For both processors, this driver has to be loaded upon boot before you can check the CPU temperature.