#!/bin/bash
#
#  Author: Pietro Balatti, Juan M. Gandarias
#  email: pietro.balatti@iit.it, jmgandarias@uma.es
#
# This script guides you to the creation of a new catkin workspace, the catkin build type (make or build) is retrieved from the config file stored in ~/.uma_params.env
#

actual_dir=$(pwd)

source $HOME/uma_environment_tools/scripts/utils.sh

# Handling options
thisfolder=0
ws_name=""
while [[ "$#" -gt 0 ]]; do
  case $1 in
  -t | --thisfolder) thisfolder=1 ;;
  -w | --ws_name) ws_name="$1" ;;
  -h | --help)
    echo -e "usage: create_catkin_ws [-t | --thisfolder] [-h | --help] [-w | --ws_name]\n\ncurrently supported options\n\tthisfolder\tcreates catkin ws in the current folder \n\tws_name  \tcreates the ws with the given name\n\thelp     \tshows this help"
    return 0
    ;;
  *)
    echo "Unknown parameter passed: $1"
    return 0
    ;;
  esac
  shift
done

# If thisfolder is not set, check within the sourced workspace
if [[ $thisfolder == 1 ]]; then
  WORKSPACE_PREFIX=$actual_dir
else
  WORKSPACE_PREFIX="$HOME/ros"
fi

# Store actual directory
actual_dir=$(pwd)
if [[ -d /opt/ros/humble ]]; then
  source /opt/ros/humble/setup.bash
else
  error "No ROS installation found. Run the ./install_ros script and come back here!"
  exit
fi

echo "New catkin workspace being created under the path \"$WORKSPACE_PREFIX\""
if [[ ! -z "$ws_name" ]]; then
  catkin_ws_name=$ws_name
else
  echo "How would you like to name you workspace? [Just press enter for \"catkin_ws\"]"
  read catkin_ws_name
fi

if [[ "$catkin_ws_name" == "" ]]; then
  catkin_ws_name="catkin_ws"
fi

pattern="[0-9a-zA-Z ]*_ws"
if [[ $catkin_ws_name != $pattern ]]; then
  catkin_ws_name+="_ws"
  warn "The workspace name was modified to $catkin_ws_name (\"_ws\" appended to the provided name)"
fi

while [[ -d ~/ros/$catkin_ws_name ]]; do
  warn "$catkin_ws_name folder already exists, choose a different one!"
  echo "Workspace name:"
  read catkin_ws_name
done

echo
echo "Creating and building a catkin workspace in \"$WORKSPACE_PREFIX/$catkin_ws_name\"..."

mkdir -p $WORKSPACE_PREFIX/$catkin_ws_name/src
cd $WORKSPACE_PREFIX/$catkin_ws_name
if [[ "$CATKIN_BUILD_TYPE" == "build" ]]; then
  catkin build
else
  catkin_make
fi

# Set new workspace
sed -i 's/WORKSPACE_TO_SOURCE=$WORKSPACES_PATH[0-9a-zA-Z_~/]*/WORKSPACE_TO_SOURCE=$WORKSPACES_PATH\/'$catkin_ws_name'/' ~/.uma_params.env
echo
source $HOME/uma_installation_tools/scripts/uma_env/uma_env.sh
echo
