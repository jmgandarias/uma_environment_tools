#!/bin/bash

# Installation guide: https://gazebosim.org/docs/garden/install_ubuntu 

# Install necessary tools
sudo apt-get update -y
sudo apt-get install lsb-release wget gnupg -y

# Install Gazebo Gardern
sudo wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
sudo apt-get update -y 
sudo apt-get install gz-garden -y