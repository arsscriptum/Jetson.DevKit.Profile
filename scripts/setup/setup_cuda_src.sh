#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/progress_cuda_cross-sbsa.log

rm -rf $TMPLOGFILE

setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}

validate_folder () {
	DIR="$1"

	setup_log "validate_folder $DIR"

	if [ ! -d "$DIR" ]; then
		setup_log "creating $DIR"
	   	mkdir $DIR
	fi
	setup_log "setting rights on $DIR"
	chmod -R 755 $DIR
}

validate_folder ~/dev/cuda
validate_folder ~/dev/cuda/download
validate_folder ~/dev/cuda/cuda-src

setup_log "Downloading cuda_gdb_src-all-all-12.1.55.tar.gz source package to ~/dev/cuda/download/cuda_gdb_src-all-all-12.1.55.tar.gz"

wget https://developer.download.nvidia.com/compute/cuda/opensource/12.1.0/cuda_gdb_src-all-all-12.1.55.tar.gz -O ~/dev/cuda/download/cuda_gdb_src-all-all-12.1.55.tar.gz -o $MYTMP/cout.log

setup_log "unpacking package cuda_gdb_src-all-all-12.1.55.tar.gz in ~/dev/cuda/cuda-src"
tar -xf ~/dev/cuda/download/cuda_gdb_src-all-all-12.1.55.tar.gz --directory ~/dev/cuda/cuda-src

setup_log "done."

cd ~/dev/cuda/cuda-src