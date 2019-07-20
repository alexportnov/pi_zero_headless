#!/bin/bash

# cleanup, then copy kernel images and device tree
rm -rf $1/kernel*.img
rm -rf $1/*.dtb
rm -rf $1/overlays/*
rm -rf $1/start4*.elf      # pi4 FW files
rm -rf $1/fixup4*.dat      # pi4 linker files
rm -rf $1/start_db.elf     # debug FW
rm -rf $1/issue.txt

