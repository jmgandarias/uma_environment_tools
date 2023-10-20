#!/bin/bash
#
#  Author: Pietro Balatti
#  email: pietro.balatti@iit.it
#
# This script stores the git remote url of the repositories in the currently sourced workspace in a config file
#
# The config file format is defined as:
# PROJECT
# repo_url: branch
# DEPENDENCIES
# repo_url: branch (commit)
# repo_url: branch (commit)
#
# repo_url example:
# git@gitlab.iit.it:hrii/general/hrii_utils.git: melodic-devel (19888b9)
#


# Script
actual_dir=`pwd`
project_repo_name=$(basename `git rev-parse --show-toplevel`);

# if the script is sourced add the trap
[[ "${BASH_SOURCE[0]}" != "${0}" ]] && trap  "{ cd $actual_dir; trap - INT; return 1; }" INT

source $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/hrii_env/hrii_env.sh
source $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/utils.sh

# Handling options
config_file_name="ws_repos.yaml";
if [[ "$#" -gt 1 ]]; then
  error "Too many arguments provided as input!";
  return 0;
elif [[ "$#" -eq 1 ]]; then
    config_file_name="$1";
    shift;
fi

# If thisfolder is not set, check within the sourced workspace
thisfolder=0 #temporarily avoiding -t command, since it is not implemented
if [[ $thisfolder == 1 ]]; then
  catkin_dir=$actual_dir
else
  catkin_dir="$WORKSPACE_TO_SOURCE/src"
fi

echo "Checking in folder: $catkin_dir"

config_file_absolute_path="$actual_dir/$config_file_name"
if [ -f $config_file_absolute_path ]; then
 echo "File $config_file_name already exists in the current directory. Do you want to overwrite it? [Y/n]"
 read ans
 if [[ "$ans" == "Y" || "$ans" == "y" || "$ans" == "" ]]; then
   warn "Overwriting existing file..."
   rm $config_file_name
 else
   warn "Ok, the file will not be overwritten. Exiting script..."
   return;
 fi
fi

warn "Creating config file in current folder: $config_file_absolute_path"
cd $catkin_dir

#catkin dir for each if folders exist
if [ "$(ls -l | grep ^d | wc -l)" == 0 ]; then
    warn "No folder found. Halting script.."
else
  for f in `cd $catkin_dir && ls -d -- */`
  do
      cd "$catkin_dir/$f"

      # remove slash char
      repo_name=${f::-1};

      # get status
      status=`git status 2>&1`;

      # check if folder is a git repository
      if echo $status|grep -qoP "fatal: not a git repository"; then
         echo -e "\e[33m$repo_name \e[39mis not a git repository.\e[39m"
      else
        # assign branch branch_name
        if echo $status|grep -qoP "On branch\s+\K([^\s]+)"; then
          branch_name=`echo $status|grep -oP "On branch\s+\K([^\s]+)"`;
        else if echo $status|grep -q "HEAD detached"; then
               branch_name=`echo $status|grep -oP "HEAD detached at\s+\K([^\s]+)"`;
             fi
        fi
        
        # get remote url origin
        url_origin=`git remote get-url origin`;
        
        # get hash Commit ID
        commit_ID=`git show -s --format=%h`;

        if [[ $repo_name == $project_repo_name ]]; then
          project_url_origin=$url_origin;
          project_branch_name=$branch_name;
          echo "$project_url_origin: $project_branch_name (project repo)"
        else
          echo "$url_origin: $branch_name ($commit_ID)"
          echo "$url_origin: $branch_name ($commit_ID)" >> $config_file_absolute_path
        fi
      fi
      cd ..
  done

  # overwrite file
  echo "$(echo -e "PROJECT\n$project_url_origin: $project_branch_name\nDEPENDENCIES" | cat - $config_file_absolute_path)" > $config_file_absolute_path
fi

# come back to the dir where the script was executed
cd $actual_dir
# possibly remove trap
trap - INT
