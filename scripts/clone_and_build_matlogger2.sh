#!/bin/bash

MATLOGGER2_FOLDER_PATH=~/git/hrii_gitlab/general/
mkdir -p $MATLOGGER2_FOLDER_PATH
cd $MATLOGGER2_FOLDER_PATH

sudo apt install -y python3-pip
pip install pybind11 -t $HOME/.local/lib/python3.8/site-packages

# If folder does not exist, clone the repo
if [[ ! -d $MATLOGGER2_FOLDER_PATH/matlogger2 ]]; then
  git clone git@gitlab.iit.it:hrii/general/matlogger2.git
fi
cd matlogger2

# Build
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. -Dpybind11_DIR=$HOME/.local/lib/python3.8/site-packages/pybind11/share/cmake/pybind11 ..
make -j`nproc`
make install
sudo make install

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/git/hrii_gitlab/general/matlogger2/build"
