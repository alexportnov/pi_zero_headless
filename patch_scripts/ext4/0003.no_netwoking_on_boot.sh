#!/bin/bash

rm -rf $1/etc/systemd/system/multi-user.target.wants/dhcpcd.service
rm -rf $1/etc/systemd/system/multi-user.target.wants/networking.service
rm -rf $1/etc/systemd/system/multi-user.target.wants/nfs-client.target
rm -rf $1/etc/systemd/system/multi-user.target.wants/wpa_supplicant.service
rm -rf $1/etc/systemd/system/multi-user.target.wants/sshswitch.service
rm -rf $1/etc/systemd/system/multi-user.target.wants/raspberrypi-net-mods.service
rm -rf $1/etc/systemd/system/multi-user.target.wants/hciuart.service
rm -rf $1/etc/systemd/system/multi-user.target.wants/dphys-swapfile.service
