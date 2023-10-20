#!/bin/bash
#
#  Author: Pietro Balatti
#  email: pietro.balatti@iit.it
#
# This script pulls all the repositories (with no untracked changes) within the sourced catkin_ws.
#

source $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/git/git_pull_repo.sh

actual_dir=`pwd`
# if the script is sourced add the trap
[[ "${BASH_SOURCE[0]}" != "${0}" ]] && trap  "{ cd $actual_dir; trap - INT; return 1; }" INT

# Repos counters
repo_count_uptodate=0
repo_count_pulled=0
repo_count_notpulled=0
repo_count_can_not_be_pulled=0

# Handling options
this_folder=0
yes_to_all=1
remote_update=0
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -opt|--option) option="$2"; shift ;;
        -t|--this_folder) this_folder=1 ;;
        #-y| --yestoall) yes_to_all=1 ;; ## now true by deafult
        -ru|--remoteupdate) remote_update=1 ;;
        -h|--help) echo -e "usage: git_pull_all [-t | --this_folder] [-ru | --remoteupdate] [-h | --help]\n\ncurrently supported options\n\tthis_folder\tsearches for git repositories in the current folder \n\tremoteupdate  \tperforms git remote update \n\thelp     \tshows this help"; return;;
        *) echo "Unknown parameter passed: $1"; return 0;;
    esac
    shift
done

# If this_folder is not set, check within the sourced workspace
if [[ $this_folder == 1 ]]; then
  catkin_dir=$actual_dir
else
  catkin_dir="$WORKSPACE_TO_SOURCE/src"
fi

echo "Checking in folder: $catkin_dir"

# If catkin_dir does not exist, use the current folder
if [ ! -d $catkin_dir ]; then
  echo "$catkin_dir not found."
  catkin_dir=$(pwd)
  echo "Use the current folder: $catkin_dir"
fi

# If compatibility problems arise, try to use $ROS_PACKAGE_PATH

echo -e "\n\e[34m                      |------------------------|";
echo -e "                      |                        |";
echo -e "                      |          HRII          |";
echo -e "                      |        GIT PULL        |";
echo -e "                      |                        |";
echo -e "                      |------------------------|\e[39m\n";

# check existence of cached credentials
#if [ "$(grep -c "helper = cache" ~/.gitconfig)" -lt 1 ]; then
#  echo "No cache credentials found, add them? [Y/n]"
#  read ans
#  if [[ "$ans" == "Y" || "$ans" == "y" || "$ans" == "" ]]; then
#    git config --global credential.helper cache
#    echo "Cache credentials  added. Insert user/password only once."
#  else
#    echo "Cache credentials not added. Insert user/password every time..."
#  fi
#fi

echo -e "\n--------------------------------------------------------------------------";



# catkin dir for each
for f in `cd $catkin_dir && ls -d -- */`
do
    folder="$catkin_dir/$f"

    # remove slash char
    folder=${folder::-1};

    git_pull_repo $folder

    echo "--------------------------------------------------------------------------";
done

echo "All the Gitlab repositories in the workspace have been checked:"
echo "   $repo_count_uptodate already up-to-date / $repo_count_pulled pulled / $repo_count_can_not_be_pulled could not be pulled"
if [[ $repo_count_notpulled -gt 1 ]]; then
  echo
  warn "          $repo_count_notpulled repos could be pulled, but were not!"
else if [[ $repo_count_notpulled -eq 1 ]]; then
        echo
        warn "          $repo_count_notpulled repo could be pulled, but was not!"
    fi
fi

# come back to the dir where the script was executed
cd $actual_dir
# possibly remove trap
trap - INT
