#!/bin/bash
#  Author: Pietro Balatti, Mattia Leonori
#  email: pietro.balatti@iit.it, mattia.leonori@iit.it
#
# This script provides an easy way to switch from one workspace to another
#

source $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/utils.sh

cd $WORKSPACES_PATH
# DIRECTORIES_LIST=$(ls)
DIRECTORIES_LIST_UNSORTED=$(find . -maxdepth 2 -type d)

# Sort directory list alphabetically
IFS=$'\n' DIRECTORIES_LIST=($(sort <<<"${DIRECTORIES_LIST_UNSORTED[*]}")); unset IFS

# Search for workspaces
echo "List of all the available ws:"
WS_PATTERN="[0-9a-zA-Z. ]*_ws"
WS_CNT=0
for DIR in ${DIRECTORIES_LIST[@]}
do
  DIR=${DIR:2}
  if [[ $DIR == $WS_PATTERN ]]; then 
    WS_CNT=$(( WS_CNT + 1 ))
    echo $WS_CNT") "$DIR
  fi
done

echo "Type the number of the desired ws:"
read DESIRED_WS

#echo "The required ws is the following: "$DESIRED_WS
WS_CNT=0
for DIR in ${DIRECTORIES_LIST[@]}
do
  if [[ $DIR == $WS_PATTERN ]]; then 
    WS_CNT=$(( WS_CNT + 1 ))
    #echo $WS_CNT") "$DIR
    if [[ $WS_CNT == $DESIRED_WS ]]; then
      #echo "Found!"
      DESIRED_WS_NAME=${DIR:2}
      break
    fi
  fi
done

echo "The desired ws is the following:" $DESIRED_WS_NAME
cd $DESIRED_WS_NAME

DESIRED_WS_NAME=$(echo $DESIRED_WS_NAME | sed 's/\//\\&/g')
sed -i 's/WORKSPACE_TO_SOURCE=$WORKSPACES_PATH[0-9a-zA-Z_~/-]*/WORKSPACE_TO_SOURCE=$WORKSPACES_PATH\/'$DESIRED_WS_NAME'/' ~/.hrii_params.env

. $HOME/.bashrc
