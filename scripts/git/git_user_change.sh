#!/bin/bash

# This script allows to change the git user config

actual_dir=`pwd`
# if the script is sourced add the trap
[[ "${BASH_SOURCE[0]}" != "${0}" ]] && trap  "{ cd $actual_dir; trap - INT; return 1; }" INT

# Store script directory, using local path removes any dependency on HRII tree
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Source utils to display colored messages
source $SCRIPT_DIR/../utils.sh

# Handling options
new_name=""
new_email=""
unset=0;
manual_email=0;
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --name) new_name="$2"; shift;;
        --email) new_email="$2"; shift;;
        --unset) unset=1;;
        --manual-email) manual_email=1;;
        -h|--help) echo -e "usage: git_user_change [--name] [--email] [--unset] [--manual_email] [-h | --help]\n";
                   echo -e "currently supported options:";
                   echo -e "\tname\t\tallows to specify the new user name";
                   echo -e "\temail\t\tallows to specify the new user email";
                   echo -e "\tunset\t\tunsets the git user ";
                   echo -e "\tmanual_email\tlet the user enter the email manually";
                   echo -e "\thelp\t\tshows this help"; return 0;;
        *) echo "Unknown parameter passed: $1"; return 0;;
    esac
    shift
done

# Welcome message
echo
blue "            |------------------------|";
blue "            |                        |";
blue "            |          HRII          |";
blue "            |     GIT USER CONFIG    |";
blue "            |                        |";
blue "            |------------------------|";
echo

# Check if a git user is found
user_name=""
user_email=""
source $SCRIPT_DIR/git_user_check.sh > /dev/null;

if [ -z "${user_name// }" ] || [ -z "${user_email// }" ]; then
  warn "No user found";
else
  echo "Current user: $user_name ($user_email)"
fi

# Ask the user new name and email
nochange=0;
if [[ -z "${new_name}" && $unset == 0 ]]; then
  echo "To switch user enter your name and surname:"
  read new_name

  if [ $manual_email == 1 ]; then
    echo "Insert email:"
    read new_email
  else
    # build and suggest potential email address based on name
    name_array=($new_name)
    if [ ${#name_array[@]} -gt 1 ]; then
      new_email="${name_array[0]}.${name_array[1]}@iit.it"
    fi
    echo
    warn "Your email has been set to $new_email."
    echo "If you'd like to enter a different email, run the script with the option --manual-email."
  fi
fi

# Set new name and email
if [ $nochange == 0 ]; then
  git config --global user.name "$new_name"
  git config --global user.email "$new_email"
  
  user_name=`cat ~/.gitconfig | grep -oP "(?<=name = ).*"`;
  user_email=`cat ~/.gitconfig | grep -oP "(?<=email = ).*"`;
  echo
  success "Current user: $user_name ($user_email)"
  
fi;

echo

# come back to the dir where the script was executed
cd $actual_dir
# possibly remove trap
trap - INT
