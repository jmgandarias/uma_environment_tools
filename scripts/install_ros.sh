#bin!/bin/bash

SCRIPT_PATH="`dirname \"$0\"`"
source "`dirname \"$0\"`"/utils.sh
source "`dirname \"$0\"`"/ros/get_ros_version.sh
get_ros_version

echo "Installing ROS $ROS_DISTRO"

if [ "$ROS_DISTRO" = "" ]; then
   error "ROS Distro to install param not set. This means you are not using Ubuntu 18.04 or 20.04. Please contact Pietro if this is not the case."
   exit
fi

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt install curl -y
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

sudo apt update -y

#ROS installation
sudo apt install -y ros-$ROS_DISTRO-desktop-full ros-$ROS_DISTRO-rqt-joint-trajectory-controller ros-$ROS_DISTRO-effort-controllers ros-$ROS_DISTRO-rosmon

#python tools installation
sudo apt install -y $PYTHON_VERSION-rosdep $PYTHON_VERSION-rosinstall $PYTHON_VERSION-rosinstall-generator $PYTHON_VERSION-wstool
sudo rosdep init
rosdep update

#install other useful tools
sudo apt install -y build-essential git-gui

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list'
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
sudo apt update -y
sudo apt install -y $PYTHON_VERSION-catkin-tools
