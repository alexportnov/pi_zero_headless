#!/bin/bash
source common.sh

# apply patches ...
set +e
cd $RUNDIR/patches
find . -type f \( -name "*.patch" -o -name "*.diff" \) | sort | while read f; do p=`echo $f | awk -F"/" '{for(i=1;i<NF;i++){printf "%s/", $i} }' `; echo $f; cat $f | patch -p1 -N -d $RUNDIR/$p; done;
set -e

# build kernel and modules
cd $KERNEL_SOURCE

make -j$(nproc) ARCH=arm CROSS_COMPILE=$TOOLCHAIN_BIN/arm-linux-gnueabihf- O=$KERNEL_OUT bcmrpi_defconfig
make -j$(nproc) ARCH=arm CROSS_COMPILE=$TOOLCHAIN_BIN/arm-linux-gnueabihf- O=$KERNEL_OUT zImage modules dtbs
