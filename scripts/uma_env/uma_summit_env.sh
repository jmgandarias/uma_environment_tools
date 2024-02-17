#!/bin/bash

# MOCA/Kairos parameters (former Robotnik original robot_params.env)
HRII_ENV_FOLDERPATH="$HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/hrii_env"
robot_hostname=$(hostname);
if [[ $robot_hostname == "SXLSK-200612AA" ]]; then
  source $HRII_ENV_FOLDERPATH/hrii_kairos_params.env
elif [[ $robot_hostname == "SXLSK-201030AA" ]]; then
  source $HRII_ENV_FOLDERPATH/hrii_rb_kairos_ur5e_oem_params.env
elif [[ $robot_hostname == "SXLS0-180704AA" ]]; then
  source $HRII_ENV_FOLDERPATH/hrii_moca_red_params.env
elif [[ $robot_hostname == "SXLS0-191024AA" ]]; then
  source $HRII_ENV_FOLDERPATH/hrii_moca_white_params.env
fi

# MOCA aliases
alias battery_time_remaining='rostopic echo /$ROBOT_ID/battery_estimator/data/time_remaining -n 1'
alias battery_voltage='rostopic echo /$ROBOT_ID/battery_estimator/data/voltage -n 1'
alias battery_level='rostopic echo /$ROBOT_ID/battery_estimator/data/level -n 1'
alias keyboard_control='roslaunch hrii_robotnik_control keyboard_controller.launch'
