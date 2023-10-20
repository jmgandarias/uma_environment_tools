#!/bin/bash
#
#  Author: Pietro Balatti
#  email: pietro.balatti@iit.it
#
# This script clones the git repos listed in the config file provided as input
#
# The config file format given as input must be defined as:
# name: user_defined_repo_name
# url: repo_url.git
# branch: repo_branch
#
# Example
# name: open_vico
# url: https://gitlab.iit.it/hrii-public/open-vico.git
# branch: noetic-devel
# ---
# name: open_vico_msgs
# url: https://gitlab.iit.it/hrii-public/open_vico_msgs.git
# branch: master
# ---
#
# Script example usage
# source /PATH/TO/SCRIPT/git_clone_repos.sh /PATH/TO/CONFIG_FILE/my_repos.yaml --exclude "repo_to_exlude_1 repo_to_exlude_2"
#

# Repositories array
unset repo_names repo_urls repo_branches config_file excluded_repos
declare repo_names repo_urls repo_branches excluded_repos
error_flag=0
exclude_flag=0

# Handling options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -e|--exclude) excluded_repos="$2"; exclude_flag=1; shift ;;
        -h|--help) echo -e "usage: git_clone_repos [-e | --exclude] [-h | --help]\n\ncurrently supported options\n\texclude  \texcludes the listed repo(s) \n\thelp     \t\tshows this help"; return 0;;
        *.yaml) echo "config file: $1"; config_file=$1;;
        *) echo "Unknown parameter passed: $1"; return 0;;
    esac
    shift
done

# Check if config file has been passed as input
if [ -z "$config_file" ]; then
  echo "No config file (.yaml) provided as input. Halting script...";
  return 0;
fi

# Check if exclude repos is active and repos to exclude have been listed
if [ $exclude_flag -eq "1" ]; then
  if [ -z "$excluded_repos" ]; then
    echo "Exclude repos active but not repos to exclude listed. Halting script...";
    return 0;
  else
    echo "Excluded repos: $excluded_repos"
  fi
fi

# Get config file path
config_file_absolute_path=$config_file
if [ ${config_file:0:1} != '/' ]; then
  config_file_absolute_path="$(pwd)/$config_file"
  config_file=${config_file_absolute_path##*/}
fi

# Process file content and assign repo names, urls, and branches to respective arrays
IFS=$'\r\n' GLOBIGNORE='*' command eval  'FILE_CONTENT=($(cat $config_file_absolute_path))';
for line in "${FILE_CONTENT[@]}"; do
  if echo $line|grep -q "name: "; then
    repo_names+=("$(echo $line|sed 's/name: //')");
  elif echo $line|grep -q "url: "; then
    repo_urls+=("$(echo $line|sed 's/url: //')");
  elif echo $line|grep -q "branch: "; then
    repo_branches+=("$(echo $line|sed 's/branch: //')");
  elif echo $line|grep -q "\-\-\-"; then
    if [ ! ${#repo_names[@]} -eq ${#repo_urls[@]} ] || [ ! ${#repo_names[@]} -eq ${#repo_branches[@]} ]; then
      error_flag="1";
    fi
  fi
done

# Double check repos counting if "---" not listed at EOF
if [ ! ${#repo_names[@]} -eq ${#repo_urls[@]} ] || [ ! ${#repo_names[@]} -eq ${#repo_branches[@]} ]; then
  error_flag="1";
fi

# Halt script if .yaml file is malformed
if [ $error_flag -eq "1" ]; then
  echo
  echo "YAML file malformed. Halting script..";
  return 0;
fi

# Split excluded_repos into array
IFS=' ' command eval 'excluded_repos=($excluded_repos)'

# Clone repos
for i in "${!repo_names[@]}"; do
  local_exclude_flag=0
  echo
  echo "Repo: ${repo_names[$i]} | url: ${repo_urls[$i]} | branch: ${repo_branches[$i]}"
  for j in "${!excluded_repos[@]}"; do
    if [ ${repo_names[$i]} = ${excluded_repos[$j]} ]; then
      echo "Repo ${excluded_repos[$j]} excluded!"
      local_exclude_flag=1
    fi
  done

  if [ $local_exclude_flag = "0" ]; then
    git clone --recursive -b ${repo_branches[$i]} ${repo_urls[$i]}
  fi
done

# End of script, final greetings
echo
echo "Repos successfully cloned!"
