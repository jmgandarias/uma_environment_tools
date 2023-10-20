#!/bin/bash

MATLOGGER2_FOLDER_PATH=~/git/hrii_gitlab/robotics/unitree
mkdir -p $MATLOGGER2_FOLDER_PATH
cd $MATLOGGER2_FOLDER_PATH

# If folder does not exist, clone the repo
if [[ ! -d $MATLOGGER2_FOLDER_PATH/rbdl ]]; then
  git clone git@gitlab.iit.it:hrii/robotics/unitree/rbdl.git
fi
cd rbdl

# Build
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. ..
make -j`nproc`
make install
sudo apt install patchelf -y