#!/bin/bash
source common.sh

EXT4=$RUNDIR/out/mnt/ext4
FAT32=$RUNDIR/out/mnt/fat32

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

# create tty bridge to ttyGS0 - serial over USB
sudo ln -sf /lib/systemd/system/getty@.service $EXT4/etc/systemd/system/getty.target.wants/getty@ttyGS0.service

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

# cleanup, then copy kernel images and device tree
sudo rm -rf $FAT32/kernel*.img
sudo rm -rf $FAT32/*.dtb
sudo rm -rf $FAT32/overlays/*
sudo rm -rf $FAT32/start4*.elf      # pi4 FW files
sudo rm -rf $FAT32/fixup4*.dat      # pi4 linker files
sudo rm -rf $FAT32/start_db.elf     # debug FW

sudo cp $KERNEL_OUT/arch/arm/boot/zImage $FAT32/kernel.img
# TODO
#sudo cp $KERNEL_OUT/arch/arm/boot/dts/*rpi-zero*.dtb $FAT32/
sudo cp $KERNEL_OUT/arch/arm/boot/dts/*.dtb $FAT32/
sudo cp $KERNEL_OUT/arch/arm/boot/dts/overlays/*.dtb* $FAT32/overlays/

sudo umount $FAT32
