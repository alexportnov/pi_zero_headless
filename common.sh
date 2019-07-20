#!/bin/bash

RUNDIR=`pwd`

KERNEL_SOURCE=$RUNDIR/kernel
KERNEL_OUT=$RUNDIR/out/kernel_out

TOOLCHAIN_DIR=$RUNDIR/toolchain

OVERLAY_DIR=$RUNDIR/overlay

EXT4=$RUNDIR/out/mnt/ext4
FAT32=$RUNDIR/out/mnt/fat32

OS_VER=`uname -i`
if [[ $OS_VER == *"x86_64"* ]]; then
    TOOLCHAIN_BIN=$TOOLCHAIN_DIR/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin
else
    TOOLCHAIN_BIN=$TOOLCHAIN_DIR/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin
fi

IMG_FILE=$RUNDIR/out/raspbian_lite_headless.img

set -e
