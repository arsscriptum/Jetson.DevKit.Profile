#!/bin/sh

mkdir /home/gp/dev/toolchain-setup
cd /home/gp/dev/toolchain-setup

echo "DOWNLOADING TOOLCHAIN"
wget https://developer.nvidia.com/embedded/jetson-linux/bootlin-toolchain-gcc-93

mkdir $HOME/l4t-gcc
cd $HOME/l4t-gcc

echo "EXTRACTING TOOLCHAIN TO $HOME/l4t-gcc"
tar -xf /home/gp/dev/toolchain-setup/aarch64--glibc--stable-final.tar.gz --directory $HOME/l4t-gcc

export CROSS_COMPILE=$HOME/l4t-gcc/bin/aarch64-buildroot-linux-gnu-

