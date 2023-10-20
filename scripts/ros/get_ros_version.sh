#!/bin/bash
#
#  Author: Pietro Balatti
#  email: pietro.balatti@iit.it
#
# Function to get ROS version
#

get_ros_version()
{
  # get release
  release=`lsb_release -r -s`;
  if [ "$release" = "18.04" ]; then
    ROS_DISTRO="melodic"
    PYTHON_VERSION="python"
  elif [ "$release" = "20.04" ]; then
    ROS_DISTRO="noetic"
    PYTHON_VERSION="python3"
  fi
}
