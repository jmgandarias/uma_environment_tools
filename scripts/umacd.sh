#!/bin/bash

REPO_NAME=$1

if [ -z "$1" ]; then
    cd ~/git/uma_github/
    return
fi

REPO_PATH_LIST=`find ~/git/uma_github/ -type d -name $REPO_NAME`

for REPO_PATH in $REPO_PATH_LIST; do
    # Check if the repo exist and contains a ".git" folder
    if [ -d "$REPO_PATH" ] && [ -d "$REPO_PATH/.git" ]; then
        cd $REPO_PATH
    fi
done
