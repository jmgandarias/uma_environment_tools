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

# Functions
# throw_error() {
#   error "Git status of repo $FOLDER_PREFIX/uma_environment_tools:"
#   echo
#   umacd uma_environment_tools && git status
#   # come back to the dir where the script was executed
#   cd $ACTUAL_DIR
# }

# build_repo() {
#   if echo $pulled_repos | grep -q "$REPO_NAME" || [ ! -d "$REPO_SRC_DIR/build" ]; then
#     echo "Building $REPO_SRC_DIR. This might take a few minutes.." | tee -a $log_file
#     cd $FOLDER_PREFIX/$REPO_SRC_DIR
#     mkdir -p build
#     cd build

#     # Building and redirecting stdout and stderr to temp file
#     if [ $REPO_NAME = "matlogger2" ]; then
#       cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. -Dpybind11_DIR=$HOME/.local/lib/python3.8/site-packages/pybind11/share/cmake/pybind11 .. 2>/tmp/uma/build_log_err_${REPO_SRC_DIR##*/}_$current_date.log >/uma/uma/build_log_out_${REPO_SRC_DIR##*/}_$current_date.log
#     else
#       cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=. .. 2>/tmp/uma/build_log_err_${REPO_SRC_DIR##*/}_$current_date.log >/tmp/uma/build_log_out_${REPO_SRC_DIR##*/}_$current_date.log
#     fi
#     make -j$(nproc) 2>>/tmp/uma/build_log_err_${REPO_SRC_DIR##*/}_$current_date.log >>/tmp/uma/build_log_out_${REPO_SRC_DIR##*/}_$current_date.log
#     if [ $REPO_NAME = "matlogger2" ]; then
#       make install
#       sudo make install
#     fi

#     # Check no error was raised in compilation
#     if grep -q "error" "/tmp/uma/build_log_err_${REPO_SRC_DIR##*/}_$current_date.log"; then
#       echo "Build error found. Contact Juanma. Script halting.." | tee -a $log_file
#       cd $ACTUAL_DIR
#       return 1
#     else
#       echo "${REPO_SRC_DIR##*/} successfully built!" | tee -a $log_file
#     fi
#   else
#     echo "Build folder already exists, not building." | tee -a $log_file
#   fi
# }

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

# repo_count_existing=0
# repo_count_cloned=0
# repo_count_pulled=0
# repo_count_deleted=0
# unpullable_repos=()
# pulled_repos=()

# Create log file
mkdir -p /tmp/uma
current_date=$(date +"%Y_%m_%d__%H_%M_%S")
log_file="/tmp/uma/install_uma_environment_$current_date.log"
echo "install_uma_environment_ log" >>$log_file

# # Pull current repo to get updated repos list
# if [ "$ignore_update" = 0 ] && [ -d $FOLDER_PREFIX/general/uma_environment_tools ]; then
#   cd $FOLDER_PREFIX/general/uma_environment_tools
#   status=$(git status)
#   echo "status: $status" >>$log_file

#   if echo $status | grep -q 'Untracked'; then
#     error "Error: uma_environment_tools cannot be pulled safely (untracked files). Please remove the files you added and execute the script once again."
#     throw_error
#     return 0
#   else
#     if echo $status | grep -q 'modified'; then
#       error "Error: uma_environment_tools cannot be pulled safely (modified files). Please stash your changes and execute the script once again."
#       throw_error
#       return 0
#     else
#       if echo $status | grep -q 'HEAD detached'; then
#         error "Error: uma_environment_tools cannot be pulled (HEAD detached). Please checkout to focal-devel and execute the script once again."
#         throw_error
#         return 0
#       else
#         #if this script is not up to date, quit
#         pull_output=$(git pull origin focal-devel 2>&1)
#         if echo $pull_output | grep -qoP "install_uma_environment.sh"; then
#           warn "New version of the script now available. Please run me again!"
#           echo
#           cd $ACTUAL_DIR
#           return 1
#         else
#           echo "Success: script up-to-date" >>$log_file
#         fi
#       fi
#     fi
#   fi
# else
#   echo "ignore_update: $ignore_update" >>$log_file
# fi

# Get updated UMA_TREE_REPOS
# if [ -d $HOME/uma_environment_tools ]; then
#   source $HOME/uma_environment_tools/scripts/github/create_github_dir.sh
# else
#   source "$ACTUAL_DIR"/github/create_github_dir.sh
# fi

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
blue "    |          $msg_keyword UMA ENVIRONMENT          |"
blue "    |                                           |"
blue "    |-------------------------------------------|"
echo

# warn "If you'll be asked to enter your password, configure the ssh keys in your account."
# warn "This can save years of your life.  Simply execute the 'create_ssh_key.sh' script!"
# echo

# Make sure that the progress bar is cleaned up when user presses ctrl+c
# enable_trapping

# Create progress bar
# setup_scroll_area
# counter=0

# for GITHUB_REPO in "${UMA_TREE_REPOS[@]}"; do
#   percentage=$((counter * 100 / ${#UMA_TREE_REPOS[@]}))
#   draw_progress_bar $percentage
#   FOLDER_PATH=$(echo ${GITHUB_REPO%/*})
#   REPO_GROUP=$(echo $FOLDER_PATH | sed 's:/.*::')
#   REPO_TO_CLONE="$SOURCE_GIT_PREFIX$GITHUB_REPO"
#   echo "Repo: $GITHUB_REPO" >>$log_file

#   # check if user has permission to access git repository
#   access_permission=$(git ls-remote $REPO_TO_CLONE 2>&1)
#   echo "access permission: $access_permission" >>$log_file
#   if echo $access_permission | grep -vqoP "fatal: Could not read from remote repository"; then
#     echo $GITHUB_REPO
#     PREV_FOLDER=$(pwd)
#     mkdir -p $FOLDER_PATH
#     DESTINATION_FOLDER=$FOLDER_PREFIX/${GITHUB_REPO:0:-4}

#     # Check if repo already exists
#     if [ ! -d $DESTINATION_FOLDER ]; then
#       git clone --recursive $REPO_TO_CLONE $DESTINATION_FOLDER
#       warn "cloned at: $DESTINATION_FOLDER"
#       repo_count_cloned=$((repo_count_cloned + 1))
#     else
#       echo "Repo already exists, not being cloned."
#       repo_count_existing=$((repo_count_existing + 1))
#       echo "Pulling repo.."
#       repo_count_can_not_be_pulled=0
#       cd $DESTINATION_FOLDER
#       repo_count_pulled_current=$repo_count_pulled
#       git_pull_repo $DESTINATION_FOLDER y

#       #if repo has been pulled
#       if [ $repo_count_pulled -gt $repo_count_pulled_current ]; then
#         pulled_repos+=($GITHUB_REPO)
#       fi

#       #if repo cannot be pulled, add it to the unpullable_repos list
#       if [ $repo_count_can_not_be_pulled -gt 0 ]; then
#         unpullable_repos+=($GITHUB_REPO)
#       fi
#       cd $FOLDER_PREFIX
#     fi

#     # Build libfranka and matlogger2
#     REPO_NAME=${GITHUB_REPO##*/}
#     REPO_NAME=${REPO_NAME:0:-4}
#     if [ "$no_build" = 0 ]; then
#       if [ $REPO_NAME = "libfranka" ] || [ $REPO_NAME = "matlogger2" ]; then
#         REPO_SRC_DIR=${GITHUB_REPO:0:-4}
#         build_repo
#       elif [ $REPO_NAME = "qbrobotics-api" ]; then
#         REPO_SRC_DIR="${GITHUB_REPO:0:-4}/serial"
#         build_repo
#         REPO_SRC_DIR="${GITHUB_REPO:0:-4}/qbrobotics-driver"
#         build_repo
#       fi
#     else
#       echo "No build option enabled" >>$log_file
#     fi
#     cd $PREV_FOLDER
#     echo
#   fi
#   counter=$((counter + 1))
# done
# destroy_scroll_area

# success "All available Github repositories have been cloned."
# echo "   $repo_count_existing already existed ($repo_count_pulled pulled) / $repo_count_cloned cloned"
# echo
# if [ ${#unpullable_repos[@]} -gt 0 ]; then
#   error "The following repos (${#unpullable_repos[@]}) could not be pulled because of untracked or modified files:"
#   for i in ${!unpullable_repos[@]}; do
#     warn "${unpullable_repos[$i]}"
#   done
# fi

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

# Clean up old repos in the UMA tree
# echo
# unset UMA_GITHUB_REPOS_TO_BE_DELETED
# repos_to_clean=0
# LOCAL_REPOS=($(find . -maxdepth 5 -type d | grep "\.git$"))
# for GITHUB_REPO in "${LOCAL_REPOS[@]}"; do
#   if [[ ! " ${UMA_TREE_REPOS[*]} " =~ " ${GITHUB_REPO:2:-5}.git " ]]; then
#     warn "${GITHUB_REPO:2:-5}"
#     UMA_GITHUB_REPOS_TO_BE_DELETED+=(${GITHUB_REPO:2:-5})
#     repos_to_clean=1
#   fi
# done

# if [ "$repos_to_clean" = 1 ]; then
#   warn "Warning: the repos listed above should not be part of the UMA local tree anymore. Do you want to remove them? [Y/n]"
#   read ans
#   if [[ "$ans" == "Y" || "$ans" == "y" || "$ans" == "" ]]; then
#     echo "Deleting the following repos:"
#     echo "${UMA_GITHUB_REPOS_TO_BE_DELETED[*]}"
#     for GITHUB_REPO in "${UMA_GITHUB_REPOS_TO_BE_DELETED[@]}"; do
#       rm -rf $GITHUB_REPO
#       parent="$GITHUB_REPO"
#       deleted_parent=1
#       while [ $deleted_parent = 1 ]; do
#         parent="$(dirname $parent)"
#         delete_empty_folder $parent
#       done
#     done
#   fi
# else
#   echo "UMA env clean"
# fi

# Edit grub default entry to enable the uma_alias reboot_to_windows
# echo
# grub_content=$(cat /etc/default/grub)
# if echo $grub_content | grep -q "GRUB_DEFAULT=saved"; then
#   echo "reboot_to_windows already enabled!" >>$log_file
# else
#   warn "Configuring grub to enable the uma_alias 'reboot_to_windows'. Prompt your password if required..."
#   echo "reboot_to_windows being enabled!" >>$log_file
#   sudo sed -i 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/' /etc/default/grub
# fi

# Install ROS 2
if [[ -d /opt/ros/humble ]]; then
  source /opt/ros/humble/setup.bash
  echo "ROS 2 already installed"
else
  echo "Installing ROS 2..."
  cd $HOME/uma_environment_tools/scripts/
  ./install_ros2.sh
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
  echo "GitKraken installation failed."
  exit 1
fi

# Go back to actual dir
cd $ACTUAL_DIR

echo
success "UMA environment succesfully created, please close and reopen the terminal before creating your first catkin workspace!"
