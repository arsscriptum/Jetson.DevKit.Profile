#!/bin/sh

mkdir /home/gp/dev/cuda/cuda-src
cd /home/gp/dev/cuda/cuda-src

echo "CUDA Toolkit Source Download"

wget https://developer.download.nvidia.com/compute/cuda/opensource/12.1.0/cuda_gdb_src-all-all-12.1.55.tar.gz -O /home/gp/dev/cuda/cuda-src/cuda_gdb_src-all-all-12.1.55.tar.gz -o $MYTMP/out.txt

echo "CUDA Toolkit Checksums"

cd /home/gp/dev/cuda/
wget https://developer.download.nvidia.com/compute/cuda/12.1.0/docs/sidebar/md5sum.txt