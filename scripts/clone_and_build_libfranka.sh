#!/bin/bash

LIBFRANKA_FOLDER_PATH=~/git/hrii_gitlab/robotics/franka
mkdir -p $LIBFRANKA_FOLDER_PATH
cd $LIBFRANKA_FOLDER_PATH

# If folder does not exist, clone the repo
if [[ ! -d $LIBFRANKA_FOLDER_PATH/libfranka ]]; then
  git clone git@gitlab.iit.it:hrii/robotics/franka/libfranka.git
fi
cd libfranka
hrii
# Build
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. ..
make -j`nproc`