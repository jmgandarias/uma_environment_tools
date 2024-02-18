#bin!/bin/bash

SCRIPT_PATH="`dirname \"$0\"`"
source "`dirname \"$0\"`"/utils.sh
source "`dirname \"$0\"`"/ros/get_ros2_version.sh
get_ros2_version

echo "Installing ROS $ROS2_DISTRO"

if [ "$ROS2_DISTRO" = "" ]; then
   error "Distro param not set. This means you are not using Ubuntu 18.04 or 20.04. Please contact Pietro if this is not the case."
   exit
fi

# The following commands have been copied and pasted 
# from https://docs.ros.org/en/galactic/Installation/Ubuntu-Install-Debians.html 2022/09/23

# Set locale and make sure to have a locale which supports UTF-8
locale  # check for UTF-8

sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings

# Setup sources
# apt-cache policy | grep universe
# Expected output 500 http://us.archive.ubuntu.com/ubuntu focal/universe amd64 Packages
#    release v=20.04,o=Ubuntu,a=focal,n=focal,l=Ubuntu,c=universe,b=amd64
sudo apt install software-properties-common
sudo add-apt-repository universe

# Authorize ROS GPG key with apt
sudo apt update && sudo apt install curl gnupg lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# Add the repository to your sources list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update -y
sudo apt upgrade -y

# ROS installation
sudo apt install -y ros-$ROS2_DISTRO-desktop
sudo apt install -y $PYTHON_VERSION-colcon-common-extensions

# Install other useful tools
sudo apt install -y build-essential git-gui

# sudo apt install -y $PYTHON_VERSION-catkin-tools

