#!/bin/bash

# Define something
STARTK=$(date +%s)
export ARCH=arm
export HOST_PLATFORM=msm
export CROSS_COMPILE=/home/daveee10/android/JBMiniProject/prebuilt/linux-x86/toolchain/linaro-4.7.1/bin/arm-eabi-
export KERNEL_DIR=`pwd`
FROM=`pwd`

# Deleting previous output
rm -f compiled/*

# Build the kernel
clear
make -j`grep 'processor' /proc/cpuinfo | wc -l`
pushd arch/arm/boot/
cp zImage $FROM/compiled/image
popd
ENDK=$(date +%s)

# Build the wifi modules
STARTW=$(date +%s)
pushd vendor_ti_wlan/sta/platforms/os/linux/
make clean
make
cp *.ko $FROM/compiled/
popd
pushd vendor_ti_wlan/ap/platforms/os/linux/
make clean
make
cp *.ko $FROM/compiled/
popd
ENDW=$(date +%s)

# Cleaning (mrproper)
STARTC=$(date +%s)
make mrproper
ENDC=$(date +%s)

# Calculating the times
ELAPSEDK=$((ENDK - STARTK))
ELAPSEDW=$((ENDW - STARTW))
ELAPSEDC=$((ENDC - STARTC))
ELAPSEDT=$((ENDC - STARTK))
EK_MIN=$((ELAPSEDK / 60))
EW_MIN=$((ELAPSEDW / 60))
EC_MIN=$((ELAPSEDC / 60))
ET_MIN=$((ELAPSEDT / 60))
EK_SEC=$((ELAPSEDK - EK_MIN * 60))
EW_SEC=$((ELAPSEDW - EW_MIN * 60))
EC_SEC=$((ELAPSEDC - EC_MIN * 60))
ET_SEC=$((ELAPSEDT - ET_MIN * 60))

# Printing the summary
clear
echo -n "[*]-------->>>> "
printf "Kernel building time: "
[ $EK_MIN != 0 ] && printf "%d min(s) " $EK_MIN
printf "%d sec(s)\n" $EK_SEC
echo -n "[*]-------->>>> "
printf "Wifi modules building time: "
[ $EW_MIN != 0 ] && printf "%d min(s) " $EW_MIN
printf "%d sec(s)\n" $EW_SEC
echo -n "[*]-------->>>> "
printf "Cleaning time: "
[ $EC_MIN != 0 ] && printf "%d min(s) " $EC_MIN
printf "%d sec(s)\n" $EC_SEC
echo -n "[*]-------->>>> "
printf "Elapsed from start: "
[ $ET_MIN != 0 ] && printf "%d min(s) " $ET_MIN
printf "%d sec(s)\n" $ET_SEC
