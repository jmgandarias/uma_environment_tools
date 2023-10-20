#!/bin/bash
#
#  Author: Pietro Balatti
#  email: pietro.balatti@iit.it
#
# This script checks the status of all the repositories within the sourced catkin_ws
#

actual_dir=`pwd`
# if the script is sourced add the trap
[[ "${BASH_SOURCE[0]}" != "${0}" ]] && trap  "{ cd $actual_dir; trap - INT; return 1; }" INT

source $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/utils.sh

# Handling options
thisfolder=0
nogui=0
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -opt|--option) option="$2"; shift ;;
        -t|--thisfolder) thisfolder=1 ;;
        -n|--no-gui) nogui=1 ;; 
        -h|--help) echo -e "usage: git_status_all [-t | --thisfolder] [-n | --no-gui] [-h | --help]\n\ncurrently supported options\n\tthisfolder\tsearches for git repositories in the current folder \n\tno-gui  \tdisables the automatic git-gui opening \n\thelp     \tshows this help"; return 0;;
        *) echo "Unknown parameter passed: $1"; return 0;;
    esac
    shift
done

# Return value, true if all the repos have nothing to be committed/pushed
clean=1;

# If thisfolder is not set, check within the sourced workspace
if [[ $thisfolder == 1 ]]; then
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

# Get Git client set in .hrii_params.env
if [[ $GIT_CLIENT == "GUI" ]]; then
  git_client="GUI"
  open_git_client="git gui"
elif [[ $GIT_CLIENT == "kraken" ]]; then
  git_client="kraken"
  open_git_client="gitkraken --path ."
else
  echo "Wrong or no git client selected in .hrii_params.env. Setting default one (git GUI)"
  git_client="GUI"
  open_git_client="git gui"
fi


# If compatibility problems arise, try to use $ROS_PACKAGE_PATH
echo
blue "                      |------------------------|";
blue "                      |                        |";
blue "                      |          HRII          |";
blue "                      |       GIT STATUS       |";
blue "                      |                        |";
blue "                      |------------------------|";
echo

global_config=`git config --global --list`;


if echo $global_config|grep -qoP "user.name="; then
  user_name=`echo $global_config|grep -oP '(?<=user.name=).*(?=user.email=)'`;
  user_email=`echo $global_config | tr " " "\n"| grep -oP '(?<=user.email=).*(?=$)'`;
else
  echo "No user found";
fi

echo -e "        Current git user: $user_name($user_email)."
echo -e "                To change it, use the \e[34mgit_user_change\e[39m script"

echo "--------------------------------------------------------------------------";

check_emptiness=`cd $catkin_dir && ls -d -- */ 2>&1`;
if echo $check_emptiness|grep -q "No such file or directory"; then
  warn "Workspace directory is empty. Exiting script..."
  cd $actual_dir
  return;
fi

#catkin dir for each
for f in `cd $catkin_dir && ls -d -- */`
do
    cd "$catkin_dir/$f"

    # remove slash char
    folder=${f::-1};

    # get status
    status=`git status 2>&1`;

    # check if folder is a git repository
    if echo $status|grep -qoP "fatal: not a git repository"; then
       echo -e "\e[33m$folder \e[39mis not a git repository.\e[39m"
    else
      # assign branch branch_name
      if echo $status|grep -qoP "On branch\s+\K([^\s]+)"; then
        branch_name=`echo $status|grep -oP "On branch\s+\K([^\s]+)"`;
      else if echo $status|grep -q "HEAD detached"; then
             branch_name="HEAD detached";
           fi
      fi

      echo -e "\e[32m$folder \e[33m($branch_name) \e[39m--> \c"

      if echo $status|grep -q 'modified'; then
          if [[ $nogui == 1 ]]; then
            echo -e "\e[31mModified files.\e[39m"
          else
            echo -e "\e[31mModified files. Open Git $git_client? [Y/n]\e[39m"
            read ans
            if [[ "$ans" == "Y" || "$ans" == "y" || "$ans" == "" ]]; then
              $open_git_client
            fi
          fi
          clean=0;
      else if echo $status|grep -q 'deleted'; then
             if [[ $nogui == 1 ]]; then
               echo -e "\e[31mDeleted files.\e[39m"
             else
               echo -e "\e[31mDeleted files. Open Git $git_client? [Y/n]\e[39m"
               read ans
               if [[ "$ans" == "Y" || "$ans" == "y" || "$ans" == "" ]]; then
                 $open_git_client
               fi
             fi
             clean=0;
           elif echo $status|grep -q 'Untracked files'; then
                if [[ $nogui == 1 ]]; then
                  echo -e "\e[31mAdded files.\e[39m"
                else
                  echo -e "\e[31mAdded files. Open Git $git_client? [Y/n]\e[39m"
                  read ans
                  if [[ "$ans" == "Y" || "$ans" == "y" || "$ans" == "" ]]; then
                    $open_git_client
                  fi
                fi
                clean=0;
           elif echo $status|grep -q 'ahead of'; then
              msg=`git status|grep 'ahead of'`
              msg="${msg:1}"
              echo -e "\e[31mnothing to commit.\nHowever, y$msg\nWould you like to push? [Y/n]\e[39m"
              read ans
              if [[ "$ans" == "Y" || "$ans" == "y" || "$ans" == "" ]]; then
                echo -e "Pushing to branch $branch_name"
                git push origin $branch_name
              fi
              clean=0;
           else
             echo -e "nothing to commit."
             sleep .05s
           fi
      fi
      fi

    echo "--------------------------------------------------------------------------";

    cd ..
done

# come back to the dir where the script was executed
cd $actual_dir
# possibly remove trap
trap - INT

return $clean;
