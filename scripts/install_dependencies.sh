#bin!/bin/bash

SCRIPT_PATH="`dirname \"$0\"`"
source $SCRIPT_PATH/utils.sh

sudo apt update -y

sudo apt install -y git
