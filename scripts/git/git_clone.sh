#!/bin/bash

REPO_NAME=$1

# if [ -z "$1" ]; then
#     cd ~/git/hrii_gitlab/
#     return
# fi

# REPO_PATH_LIST=`find ~/git/hrii_gitlab/ -type d -name $REPO_NAME`

# for REPO_PATH in $REPO_PATH_LIST; do
#     # Check if the repo exist and contains a ".git" folder
#     if [ -d "$REPO_PATH" ] && [ -d "$REPO_PATH/.git" ]; then
#         cd $REPO_PATH
#     fi
# done
git clone --recursive git@gitlab.iit.it:hrii/$REPO_NAME