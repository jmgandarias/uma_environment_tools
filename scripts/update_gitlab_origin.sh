#!/bin/bash

update_gitlab_origin() {
    CURRENT_DIR=`pwd`
    echo $CURRENT_DIR

    PREV_ORIGIN=`git remote get-url origin`
    echo ${PREV_ORIGIN:0:26}
    echo ${PREV_ORIGIN:0:18}
#    echo ${PREV_ORIGIN:0:26}
    # PREV_ORIGIN="https://gitlab.advr.iit.it/hrii/robotics/sandbox/hrii_two_r"
    echo "Previous origin URL: "$PREV_ORIGIN
    if [ "${PREV_ORIGIN:0:26}" == "https://gitlab.advr.iit.it" ]; then
        NEW_ORIGIN=git@gitlab.iit.it:${PREV_ORIGIN:27}
    elif [ "${PREV_ORIGIN:0:22}" == "git@gitlab.advr.iit.it" ]; then
        NEW_ORIGIN=git@gitlab.iit.it:${PREV_ORIGIN:23}
    elif [ "${PREV_ORIGIN:0:18}" == "git@gitlab.iit.it/" ]; then
	    NEW_ORIGIN=git@gitlab.iit.it:${PREV_ORIGIN:18}
    else
        echo "\"https://gitlab.advr.iit.it\" or \"git@gitlab.advr.iit.it\" substring not found in previous origin URL."
        return
    fi

    echo "New origin URL: "$NEW_ORIGIN
    git remote set-url origin $NEW_ORIGIN
}


# git@gitlab.advr.iit.it:hrii/robotics/common/hrii_robot_interface.git
# https://gitlab.advr.iit.it/hrii/robotics/sandbox/hrii_two_r
