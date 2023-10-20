#!/bin/bash

# This script checks if a git user is configured

# if the script is sourced add the trap
[[ "${BASH_SOURCE[0]}" != "${0}" ]] && trap  "{ cd $actual_dir; trap - INT; return 1; }" INT

# Store script directory, using local path removes any dependency on HRII tree
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Source utils to display colored messages
source $SCRIPT_DIR/../utils.sh

# Store user name and email
user_name=`cat ~/.gitconfig | grep -oP "(?<=name = ).*"`;
user_email=`cat ~/.gitconfig | grep -oP "(?<=email = ).*"`;

# Check if a git user name is found
if [ -z "${user_name// }" ] && [ -z "${user_email// }" ]; then
  warn "No git user configured. Before committing any change, run the \"git_user_change\" command.";
else
  # Check if a git user name is found
  if [ -z "${user_name// }" ]; then
    warn "No git user name configured. Before committing any change, run the \"git_user_change\" command.";
  fi

  # Check if a git user email is found
  if [ -z "${user_email// }" ]; then
    warn "No git user email configured. Before committing any change, run the \"git_user_change\" command.";
  fi
fi

# possibly remove trap
trap - INT
