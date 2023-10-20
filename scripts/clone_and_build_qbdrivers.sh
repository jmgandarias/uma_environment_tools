#!/bin/bash

QBDRIVERS_FOLDER_PATH=~/git/hrii_gitlab/robotics/grippers/
mkdir -p $QBDRIVERS_FOLDER_PATH
cd $QBDRIVERS_FOLDER_PATH
echo $QBDRIVERS_FOLDER_PATH
ls
# If folder does not exist, clone the repo
if [[ ! -d $QBDRIVERS_FOLDER_PATH/qbrobotics-api ]]; then
  git clone git@gitlab.iit.it:hrii/robotics/grippers/qbrobotics-api.git
fi
ls
cd qbrobotics-api/serial

# Build
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. ..
make -j`nproc`

cd $QBDRIVERS_FOLDER_PATH
cd qbrobotics-api/qbrobotics-driver

# Build
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. ..
make -j`nproc`



# cd $HOME/git/hrii_gitlab/robotics/grippers/qbrobotics-api/serial/
# mkdir build
# cd build
# cmake -DCMAKE_INSTALL_PREFIX=. ..
# make -j`nproc`
# cd $HOME/git/hrii_gitlab/robotics/grippers/qbrobotics-api/qbrobotics-driver/
# mkdir build
# cd build
# cmake -DCMAKE_INSTALL_PREFIX=. ..
# make -j`nproc`
