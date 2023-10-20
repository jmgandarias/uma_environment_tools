#bin!/bin/bash

SCRIPT_PATH="`dirname \"$0\"`"
source "`dirname \"$0\"`"/utils.sh
source "`dirname \"$0\"`"/ros/get_ros2_version.sh
get_ros2_version

echo "Uninstalling ROS $ROS2_DISTRO"


if [ "$ROS2_DISTRO" = "" ]; then
   error "Distro param not set. This means you are not using Ubuntu 18.04 or 20.04. Please contact Pietro if this is not the case."
   exit
fi

# The following commands have been copied and pasted 
# from https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html 2022/09/23

# Remove ROS binaries
sudo apt remove ~nros-$ROS2_DISTRO-* && sudo apt autoremove

# Remove the repository
sudo rm /etc/apt/sources.list.d/ros2.list
sudo apt update
sudo apt autoremove
# Consider upgrading for packages previously shadowed.
sudo apt upgrade
