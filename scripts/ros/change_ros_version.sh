#!/bin/bash
#  Author: Pietro Balatti, Mattia Leonori
#  email: pietro.balatti@iit.it, mattia.leonori@iit.it
#
# This script provides an easy way to switch from one ROS version to another
#

source $HOME/uma_environment/uma_environment_tools/scripts/utils.sh

# Search for workspaces
echo "List of all ROS versions:"
echo "1) "$ROS_DISTRO_TO_INSTALL
echo "2) "$ROS2_DISTRO_TO_INSTALL

echo "Type the number of the desired ROS version:"
read DESIRED_ROS_VERSION

if [ $DESIRED_ROS_VERSION == 1 ]; then
    DESIRED_ROS_VERSION_NAME=$ROS_DISTRO_TO_INSTALL
elif [ $DESIRED_ROS_VERSION == 2 ]; then
    DESIRED_ROS_VERSION_NAME=$ROS2_DISTRO_TO_INSTALL
else 
    error "Not valid ROS version."
    quit
fi
echo "The required ROS version is the following: "$DESIRED_ROS_VERSION_NAME
sed -i 's/ROS_DISTRO_TO_SOURCE=[0-9a-zA-Z_~/-]*/ROS_DISTRO_TO_SOURCE='$DESIRED_ROS_VERSION_NAME'/' ~/.hrii_params.env

# . $HOME/.bashrc
