#!/bin/bash
source common.sh

# apply patches ...
find $RUNDIR/patches -type f \( -name "*.patch" -o -name "*.diff" \) | sort | while read f; do p=`echo $f | awk -F"/" '{for(i=1;i<NF;i++){printf "%s/", $i} }' `; echo $f; cat $f | patch -p1 -N -d $RUNDIR/$p; done;


# build kernel and modules
cd $KERNEL_SOURCE

make -j$(nproc) ARCH=arm CROSS_COMPILE=$TOOLCHAIN_BIN/arm-linux-gnueabihf- O=$KERNEL_OUT bcmrpi_defconfig
make -j$(nproc) ARCH=arm CROSS_COMPILE=$TOOLCHAIN_BIN/arm-linux-gnueabihf- O=$KERNEL_OUT zImage modules dtbs
