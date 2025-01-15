#!/bin/bash
#
# Author: Juan M. Gandarias
# email: jmgandarias@uma.es
#
# Thanks to the support of the HRII Technicians <3
#
# This script installs or updates the UMA environment.
#

# Store actual directory
ACTUAL_DIR=$(pwd)

# If first installation source current dir, otherwise (update) uma tree's one
if [ -d $HOME/uma_environment_tools ]; then
  source $HOME/uma_environment_tools/scripts/utils.sh
  # source $HOME/uma_environment_tools/scripts/git/git_pull_repo.sh
  # source $HOME/uma_environment_tools/scripts/progress_bar.sh
else
  source "$ACTUAL_DIR"/utils.sh
  # source "$ACTUAL_DIR"/progress_bar.sh
fi

# Handling options
ignore_update=0
no_build=0
while [[ "$#" -gt 0 ]]; do
  case $1 in
  -i | --ignoreupdate) ignore_update=1 ;;
  -nb | --nobuild) no_build=1 ;;
  -h | --help)
    echo -e "usage: install_uma [-h | --help]\n\ncurrently supported options\n\thelp     \tshows this help"
    return 1
    ;;
  *) echo "Unknown parameter passed: $1" ;;
  esac
  shift
done

delete_empty_folder() {
  if [ -z "$(ls -A $parent)" ]; then
    rm -rf $parent
    deleted_parent=1
  else
    deleted_parent=0
  fi
}

# Local variables
# SOURCE_GIT_PREFIX="git@github.com:Robotics-Mechatronics-UMA/"
FOLDER_PREFIX=~/uma_environment_tools

# Script implementation
if [ ! -d $FOLDER_PREFIX ]; then
  mkdir -p $FOLDER_PREFIX
  msg_keyword="CREATE"
else
  msg_keyword="UPDATE"
fi
cd $FOLDER_PREFIX

# Print intro message
echo
blue "    |-------------------------------------------|"
blue "    |                                           |"
blue "    |          $msg_keyword UMA ENVIRONMENT           |"
blue "    |                                           |"
blue "    |-------------------------------------------|"
echo

# Create log file
mkdir -p /tmp/uma
current_date=$(date +"%Y_%m_%d__%H_%M_%S")
log_file="/tmp/uma/install_uma_environment_$current_date.log"
echo "install_uma_environment_ log" >>$log_file

# Install packages
echo
echo "Installing packages..." | tee -a $log_file
declare -a required_pkgs=("arp-scan" "git-gui" "python3-pip" "ros-humble-plotjuggler-ros" "terminator" "python3-testresources" "dialog")
declare -a required_pip3_pkgs=("tk" "h5py" "pymodbus" "matplotlib" "Twisted" "pybind11")

# Check required packages installation status
for pkg in "${required_pkgs[@]}"; do
  pkg_output=$(apt-cache policy $pkg)
  if echo $pkg_output | grep -q 'Installed: (none)'; then
    echo "$pkg newly installed" >>$log_file
    sudo apt install -y $pkg
  fi
done

# Check required pip3 packages installation status
pip3_installed_pkgs=$(pip3 list)
for pip3_pkg in "${required_pip3_pkgs[@]}"; do
  if echo $pip3_installed_pkgs | grep -qv $pip3_pkg; then
    echo "$pip3_pkg newly installed" >>$log_file
    pip3 install $pip3_pkg -t $HOME/.local/lib/python3.8/site-packages
  fi
done




# Check if UMA environment is already sourced in .bashrc
bashrc_content=$(cat $HOME/.bashrc)
path_to_be_sourced="/uma_environment_tools/scripts/uma_env/uma_"
if echo $bashrc_content | grep -q "$path_to_be_sourced"; then
  echo ".bashrc already sourced" >>$log_file
else
  echo "source $HOME/uma_environment_tools/scripts/uma_env/uma_env.sh" >>~/.bashrc
fi

# .uma_params update check
echo
if [ ! -f ~/.uma_params.env ]; then
  # No link, copied so that is not affected by future pulls
  echo ".uma_params.env newly created" >>$log_file
  cp $HOME/uma_environment_tools/scripts/uma_env/uma_params.env ~/.uma_params.env
  uma_params_out=$(cat ~/.uma_params.env)
  blue "$uma_params_out"
  echo
  warn ".uma_params.env has been created. The current settings are listed above in blue."
  warn "You can enter your personal settings by running the command \"modify_uma_params\"."
else
  #Check if current version is the latest
  # get last version
  str_before_version="# UMA PARAMS "
  uma_params_file=$(cat $HOME/uma_environment_tools/scripts/uma_env/uma_params.env)
  LAST_VERSION="${uma_params_file#*$str_before_version}"
  LAST_VERSION="${LAST_VERSION:0:5}"
  uma_params_content=$(cat $HOME/.uma_params.env)
  uma_params_version="UMA PARAMS $LAST_VERSION"
  if echo $uma_params_content | grep -q "$uma_params_version"; then
    echo ".uma_params.env already up-to-date ($LAST_VERSION)."
  else
    # Store current settings
    current_ws="${WORKSPACE_TO_SOURCE##*/}"
    # No link, copied so that is not affected by future pulls
    cp $HOME/uma_environment_tools/scripts/uma_env/uma_params.env ~/.uma_params.env
    # Restore user workspace
    sed -i 's/WORKSPACE_TO_SOURCE=$WORKSPACES_PATH[0-9a-zA-Z_~/]*/WORKSPACE_TO_SOURCE=$WORKSPACES_PATH\/'$current_ws'/' ~/.uma_params.env
    warn ".uma_params.env has been updated to latest version ($LAST_VERSION)."
    warn "To edit your personal settings run the command \"modify_uma_params\""
  fi
fi

# Create log directory
if [ ! -d $HOME/log ]; then
  mkdir $HOME/log
fi

# Create ros directory
if [ ! -d $HOME/ros ]; then
  mkdir -p $HOME/ros
fi

# Clean up old uma env files, if present
if [ -d $HOME/.uma_env ]; then
  rm -rf $HOME/.uma_env
fi
if [ -L $HOME/log/DataPlotterHandler.py ]; then
  rm -f $HOME/log/DataPlotterHandler.py
fi
if [ -L $HOME/log/plot_logged_data2.py ]; then
  rm -f $HOME/log/plot_logged_data2.py
fi
if [ -d $HOME/ros/ros_package_links ]; then
  rm -rf $HOME/ros/ros_package_links
fi

# Install ROS 2
if [[ -d /opt/ros/humble ]]; then
  source /opt/ros/humble/setup.bash
  echo "ROS 2 already installed"
else
  echo "Installing ROS 2..."
  cd $HOME/uma_environment_tools/scripts/
  ./install_ros2.sh
  cd -
fi

# Install plostjuggler
# Check if PlotJuggler is installed
if command -v plotjuggler &>/dev/null; then
  echo "PlotJuggler is already installed."
else
  echo "Installing PlotJuggler..."
  sudo apt install ros-$ROS_DISTRO_TO_SOURCE-plotjuggler-ros
fi

# Install Nautilus
if command -v nautilus &>/dev/null; then
  echo "Nautilus is already installed."
else
  echo "Installing Nautilus..."
  sudo apt install nautilus
fi

#Install Gitkraken
if command -v gitkraken &>/dev/null; then
  echo "GitKraken already installed."
else
  echo 
  cd $HOME/uma_environment_tools/scripts/
  sudo ./install_gitkraken.sh
  cd -
fi

#Install Gazebo
if command -v gazebo &>/dev/null; then
  echo "Gazebo already installed."
else
  echo "Installing Gazebo..."
  sudo apt install gazebo
fi

# Go back to actual dir
cd $ACTUAL_DIR

echo

# Final message
if [[ "$msg_keyword" == "CREATE" ]]; then
  success "UMA environment succesfully created, please close and reopen the terminal before creating your first catkin workspace!"
  echo "Remember to create and build a catkin_ws."
  echo "You can use the aliases create_catkin_ws and cb."
  echo "Remember to close and open a new terminal and run update_uma_environment to finish the installation."
else
  success "UMA environment succesfully updated, please close and reopen the terminal before creating your first catkin workspace!"
fi
