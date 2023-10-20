#!/bin/bash
#
#  Author: Pietro Balatti
#  email: pietro.balatti@iit.it
#
# Function to get ROS2 version
#

get_ros2_version()
{
  # get release
  release=`lsb_release -r -s`;
  if [ "$release" = "20.04" ]; then
    ROS2_DISTRO="foxy"
    PYTHON_VERSION="python3"
  elif [ "$release" = "22.04" ]; then
    ROS2_DISTRO="humble"
    PYTHON_VERSION="python3"
  fi
}
