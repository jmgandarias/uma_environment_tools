#!/bin/bash
#
#  Author: Pietro Balatti
#  email: pietro.balatti@iit.it
#
# This script clones the git repos listed in the config file provided as input, in the currently sourced workspace
#
# The config file format given as input must be defined as:
# PROJECT
# repo_url: branch
# DEPENDENCIES
# repo_url: branch (commit)
# repo_url: branch (commit)
#
# repo_url example:
# git@gitlab.iit.it:hrii/general/hrii_utils.git: melodic-devel (19888b9)
#

# Repositories array
unset repo_urls repo_branches repo_commits
declare -A repo_urls repo_branches repo_commits

deprecated_flag=false;

# Functions
parseYaml(){
    IFS=$'\r\n' GLOBIGNORE='*' command eval  'REPOS=($(cat $config_file_absolute_path))';
    # Check if the file is well-formed
    CONFIG_FILE_CONTENT=$(cat $config_file_absolute_path);
    if ! echo $CONFIG_FILE_CONTENT|grep -q "PROJECT"; then
      warn "PROJECT keyword not found, yaml file malformed (or deprecated)"
      deprecated_flag=true;
    fi

    if ! echo $CONFIG_FILE_CONTENT|grep -q "DEPENDENCIES"; then
      warn "DEPENDENCIES keyword not found, yaml file malformed (or deprecated)"
      deprecated_flag=true;
    fi

    if [[ $deprecated_flag = false ]]; then
      # Store repo url, branch and commit in the arrays repo_urls,repo_branches,repo_commits
      for repo in "${REPOS[@]}"; do
        if [[ $repo = "PROJECT" ]]; then
          project_keyword=true;
        elif [[ $project_keyword = true ]]; then
          project_repo_url=$(echo $repo|sed 's/\.git.*/.git/');
          project_repo_name=$(echo $project_repo_url|sed 's/\.git.*//'|sed 's@.*/@@');
          project_repo_branch_commit=$(echo $repo|sed 's/^.*git: //');
          project_repo_branch=$(echo $project_repo_branch_commit|sed 's/ (.*//');
          project_keyword=false;
        elif [[ $repo = "DEPENDENCIES" ]]; then
          dependencies_keyword=true;
        elif [[ $dependencies_keyword = true ]]; then
          repo_url=$(echo $repo|sed 's/\.git.*/.git/');
          repo_name=$(echo $repo_url|sed 's/\.git.*//'|sed 's@.*/@@');
          repo_branch_commit=$(echo $repo|sed 's/^.*git: //');
          repo_branch=$(echo $repo_branch_commit|sed 's/ (.*//');
          repo_commit=$(echo $repo_branch_commit|sed 's/.*(\(.*\))/\1/');
          
          # Create arrays (sort of C struct) to store repos' information
          repo_urls[$repo_name]=$repo_url;
          repo_branches[$repo_name]=$repo_branch;
          repo_commits[$repo_name]=$repo_commit;
        fi
      done
    else
      warn "Running deprecated script.."
      for repo in "${REPOS[@]}"; do
        repo_url=$(echo $repo|sed 's/\.git.*/.git/');
        repo_name=$(echo $repo_url|sed 's/\.git.*//'|sed 's@.*/@@');
        repo_branch_commit=$(echo $repo|sed 's/^.*git: //');
        repo_branch=$(echo $repo_branch_commit|sed 's/ (.*//');
        repo_commit=$(echo $repo_branch_commit|sed 's/.*(\(.*\))/\1/');
        
        # Create arrays (sort of C struct) to store repos' information
        repo_urls[$repo_name]=$repo_url;
        repo_branches[$repo_name]=$repo_branch;
        repo_commits[$repo_name]=$repo_commit;
      done
    fi
}

cleanWorkspace(){
  # Cleaning all the workspace a part from CMakeLists.txt

  success "Workspace clean!"

  current_dir=`pwd`
  cd $WORKSPACE_TO_SOURCE/src
  if [ "$(ls | wc -l)" -gt 0 ]; then
    old_ws_name="/tmp/ws_$(date "+%F_%H_%M_%S")"
    warn "Moving existing repos in $old_ws_name"
    mkdir $old_ws_name
    mv -v !("CMakeLists.txt"|"robotnik_hw") $old_ws_name/
  fi

  # if current_dir does not exits, it means the script was run inside the cleaned ws, so we take the config from a copy made in tmp folder (tmp_ws_repos.yaml)
  if [ ! -d $current_dir ]; then
    config_file_absolute_path="/tmp/tmp_ws_repos.yaml"
    warn "Using a copy of input config file (/tmp/tmp_ws_repos.yaml), your copy has been deleted by the workspace cleaning."
  else
    cd $current_dir
  fi

  success "Checking out the repositories listed in:"
  echo $config_file_absolute_path
  echo
  cat $config_file_absolute_path
  echo
}

# Script
actual_dir=`pwd`
# if the script is sourced add the trap
[[ "${BASH_SOURCE[0]}" != "${0}" ]] && trap  "{ cd $actual_dir; trap - INT; return 1; }" INT

source $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/utils.sh

# Config file passed as argument
if [[ "$#" -lt 1 ]];then
  error "No config file provided as argument, terminating the script..."
  return;
fi

# Handling options
commit_checkout=0
while [[ "$#" -gt 0 ]]; do
    echo "input: $1"
    case $1 in
        -opt|--option) option="$1"; shift ;;
        -cc|--commit_checkout) commit_checkout=1 ; echo -e "commit_checkout enabled";;
        -h|--help) echo -e "usage: git_import_repos [-cc | --commit_checkout] [-h | --help]\n\ncurrently supported options\n\tcommit_checkout  \tchecks out the repo commit_ID \n\thelp     \t\tshows this help"; return 0;;
        *.yaml) echo "config file: $1"; config_file=$1;;
        *) echo "Unknown parameter passed: $1"; return 0;;
    esac
    shift
done

config_file_absolute_path=$config_file
if [ ${config_file:0:1} != '/' ]; then
  config_file_absolute_path="$(pwd)/$config_file"
  config_file=${config_file_absolute_path##*/}
fi

# Check git status of the repos contained in the workspace
echo "Checking WS: $WORKSPACE_TO_SOURCE"
source $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/git/git_status_all.sh -n
echo

if [[ $clean == 1 ]]; then
  # Use "getConfigFile" to automatically get the config file located in the current folder
  #getConfigFile

  if [ ! -f $config_file_absolute_path ]; then
    error "No config file found, terminating the script..."
    echo
    return;
  fi

  # Copy yaml file in /tmp, useful if script run inside sourced ws that gest clean by this script
  cp $config_file_absolute_path /tmp/tmp_ws_repos.yaml

  cleanWorkspace
  
  parseYaml
  
  cd $WORKSPACE_TO_SOURCE/src
  
  echo "--------------------------------------------------------------------------";

  if [[ $deprecated_flag = false ]]; then
    warn "Main project repo: $project_repo_name | url: $project_repo_url | branch: $project_repo_branch"
    git clone --recursive -b $project_repo_branch $project_repo_url
    if [[ $commit_checkout == 1 ]]; then
      cd $project_repo_name
      cd ..
    fi
  fi

  for i in "${!repo_urls[@]}"
  do
    warn "Repo: $i | url: ${repo_urls[$i]} | branch: ${repo_branches[$i]} | commit: ${repo_commits[$i]}"
    git clone --recursive -b ${repo_branches[$i]} ${repo_urls[$i]} 
    if [[ $commit_checkout == 1 ]]; then
      cd $i 
      git checkout ${repo_commits[$i]}
      cd ..
    fi
  done
else
  warn "Workspace not clean, aborting script. Please commit or stash your changes in the repos listed above!\n"
fi

# come back to the dir where the script was executed
cd $actual_dir
# possibly remove trap
trap - INT
