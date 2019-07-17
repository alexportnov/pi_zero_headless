#!/bin/bash
source common.sh

#########################################################################################
# download and install pre-req - tested on Ubuntu18.04LTS
sudo apt-get install git bc bison flex libssl-dev build-essential make curl

#########################################################################################
echo "-------------- Fetch kernel --------------"
if [ -e $KERNEL_SOURCE ]; then
    cd $KERNEL_SOURCE
    git pull
else
    # tested on --branch rpi-4.19.y
    git clone --depth=1 https://github.com/raspberrypi/linux $KERNEL_SOURCE
fi

#########################################################################################
echo "-------------- Fetch toolchain --------------"
cd $RUNDIR
if [ -e $TOOLCHAIN_DIR ]; then
    cd $TOOLCHAIN_DIR
    git pull
else
    git clone --depth=1 https://github.com/raspberrypi/tools $TOOLCHAIN_DIR
fi

#########################################################################################
cd $RUNDIR
echo "-------------- Get latest packed image --------------"
# tested on http://director.downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-07-12/2019-07-10-raspbian-buster-lite.zip

LATEST_URL=`curl -L --head -w '%{url_effective}' https://downloads.raspberrypi.org/raspbian_lite_latest  2>/dev/null | tail -n1`
LATEST_FILE="${LATEST_URL##*/}"

mkdir -p $RUNDIR/out
# TODO: check expected size
if [ ! -f $LATEST_FILE ]; then
    wget $LATEST_URL
else
    echo "$LATEST_FILE already exists"
fi

unzip $LATEST_FILE -d $RUNDIR/out/
LAST_FILE=`ls -t $RUNDIR/out/*.img | head -1`
rm $IMG_FILE
mv $LAST_FILE $IMG_FILE

echo "-------------- Done --------------"
