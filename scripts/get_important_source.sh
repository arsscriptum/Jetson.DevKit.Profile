#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/get_important_source.progress.log

rm -rf $TMPLOGFILE

setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}


cd /home/gp/dev

setup_log "========== CLONE SOURCE START ========="

git clone --recursive https://github.com/dusty-nv/jetson-inference
git clone --branch v0.7.0 https://github.com/pytorch/vision torchvision

setup_log "========== BUILD SOURCE START ========="
setup_log "BUILDING JETSON INFERENCE" 

cd /home/gp/dev/jetson-inference
mkdir build && cd build
cmake ../

make 
sudo make install

sudo ldconfig

setup_log "========== TORCH VISION =========" 

cd /home/gp/dev/torchvision
export BUILD_VERSION=0.7.0 

setup_log "======================================"
setup_log "When installing torchvision, running sudo python setup.py install takes a long time. Be patient!"
python3 setup.py install --user

setup_log "SETUP.PY DONE"

cd ../
pip install 'pillow<7'

cd /home/gp/dev/jetson-inference/python/training/detection/ssd

setup_log "======================================"
setup_log "Download pre-trained model"
wget https://nvidia.box.com/shared/static/djf5w54rjvpqocsiztzaandq1m3avr7c.pth -O models/mobilenet-v1-ssd-mp-0_675.pth

setup_log "======================================"
setup_log "Download custom dataset from Kaggle"
wget https://www.kaggle.com/andrewmvd/face-mask-detection/metadata

setup_log "Please continue to https://www.hackster.io/shahizat/face-mask-detection-system-using-ai-and-nvidia-jetson-board-3cfae7"


