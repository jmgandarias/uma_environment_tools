#!/bin/bash
#
#  Author: Juan M. Gandarias
#  email: jmgandarias@uma.es
#
# This script guides you to the creation of a new ros2 package
#

actual_dir=`pwd`

source $HOME/uma_environment/uma_environment_tools/scripts/utils.sh

# Handling options
thisfolder=0
pkg_name="";
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--pkg_name) pkg_name="$1";;
        -h|--help) echo -e "usage: create_ros2_pkg [-t | --thisfolder] [-h | --help] [-w | --pkg_name]\n\ncurrently supported options\n\tthisfolder\tcreates ros2 pkg in the current folder \n\tpkg_name  \tcreates the pkg with the given name\n\thelp     \tshows this help"; return 0;;
        *) echo "Unknown parameter passed: $1"; return 0;;
    esac
    shift
done

# Store actual directory
actual_dir=`pwd`

echo "New ros2 package being created"
if [[ ! -z "$pkg_name" ]]; then
  ros2_pkg_name=$pkg_name;
else
  echo "How would you like to name your package? [Just press enter for \"my_pkg\"]"
  read ros2_pkg_name
fi

if [[ "$ros2_pkg_name" == "" ]]; then
  ros2_pkg_name="my_pkg"
fi

while [[ -d actual_dir/$ros2_pkg_name ]]; do
  warn "$ros2_pkg_name already exists, choose a different one!"
  echo "Package name:"
  read ros2_pkg_name
done

echo
echo "Creating the ros2 pkg"

ros2 pkg create --build-type ament_cmake $ros2_pkg_name
cd $ros2_pkg_name
mkdir launch
cd ../..
cb


