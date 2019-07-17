#!/bin/bash
source common.sh

# TODO: apply paches ...


# build kernel and modules
cd $KERNEL_SOURCE

make -j$(nproc) ARCH=arm CROSS_COMPILE=$TOOLCHAIN_BIN/arm-linux-gnueabihf- O=$KERNEL_OUT bcmrpi_defconfig
make -j$(nproc) ARCH=arm CROSS_COMPILE=$TOOLCHAIN_BIN/arm-linux-gnueabihf- O=$KERNEL_OUT zImage modules dtbs
