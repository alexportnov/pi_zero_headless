#!/bin/bash
source common.sh

mkdir -p $EXT4
mkdir -p $FAT32

#########################################################################################
# repack ext4 partition
EXT4_SECTOR_OFFSET=$(fdisk -l $IMG_FILE | awk '$7 == "Linux" { print $2 }')
sudo mount -o loop,offset=$((512 * $EXT4_SECTOR_OFFSET)) $IMG_FILE $EXT4

# overlay
if [ "$(ls -A $RUNDIR/overlay/ext4)" ]; then
    sudo cp -r $RUNDIR/overlay/ext4/* $EXT4/
fi

# patch the fs
if [ "$(ls -A $RUNDIR/patch_scripts/ext4)" ]; then
    find $RUNDIR/patch_scripts/ext4 -type f \( -name "*.sh" \) | sort | while read f; do echo $f; sudo bash $f $EXT4; done;
fi

# install compiled kernel modules
sudo rm -rf $EXT4/lib/modules/*
cd $KERNEL_SOURCE
sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=$TOOLCHAIN_BIN/arm-linux-gnueabihf- O=$KERNEL_OUT INSTALL_MOD_PATH=$EXT4 modules_install
cd $RUNDIR

sudo umount $EXT4

#########################################################################################
# repack msdos partition
FAT32_SECTOR_OFFSET=$(fdisk -l $IMG_FILE | awk '$7 == "W95" { print $2 }')
sudo mount -o loop,offset=$((512 * $FAT32_SECTOR_OFFSET)) $IMG_FILE $FAT32

# overlay
if [ "$(ls -A $OVERLAY_DIR/fat32)" ]; then
    sudo cp -r $OVERLAY_DIR/fat32/* $FAT32/
fi

# patch the fs
if [ "$(ls -A $RUNDIR/patch_scripts/fat32)" ]; then
    find $RUNDIR/patch_scripts/fat32 -type f \( -name "*.sh" \) | sort | while read f; do echo $f; sudo bash $f $FAT32; done;
fi


sudo cp $KERNEL_OUT/arch/arm/boot/zImage $FAT32/kernel.img
sudo cp $KERNEL_OUT/arch/arm/boot/dts/bcm2708-rpi-zero*.dtb $FAT32/
sudo cp $KERNEL_OUT/arch/arm/boot/dts/overlays/*.dtb* $FAT32/overlays/


sudo umount $FAT32
