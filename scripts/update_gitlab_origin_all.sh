#!/bin/bash

source "`dirname \"$0\"`"/utils.sh
# source "`dirname \"$0\"`"/gitlab/create_gitlab_dir.sh
source "`dirname \"$0\"`"/update_gitlab_origin.sh

echo "Update all git url origin..."
echo 

my_array=()
while IFS= read -r line; do
    # read mimmo
    echo "${line:0:-5}"
    PREV_FOLDER=`pwd`
    cd ${line:0:-5}
    update_gitlab_origin
    cd $PREV_FOLDER
done < <( find . -name .git -type d -prune )
