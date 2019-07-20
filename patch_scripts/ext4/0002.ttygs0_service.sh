#!/bin/bash

ln -sf /lib/systemd/system/getty@.service $1/etc/systemd/system/getty.target.wants/getty@ttyGS0.service

