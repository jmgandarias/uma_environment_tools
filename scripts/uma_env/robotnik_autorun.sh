#!/bin/bash

export ROS_MASTER_URI=http://$HOSTNAME:11311
export ROS_HOSTNAME=$HOSTNAME

# HRII source
source ~/.hrii_params.env
source /opt/ros/$ROS_DISTRO_TO_INSTALL/setup.bash
source $WORKSPACE_TO_SOURCE/devel/setup.bash

#source robot params
source $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/hrii_env/hrii_summit_env.sh

# SUMMIT XL
# AUTOBOOT
echo "ROBOTNIK SUMMIT XL v2.0"

killall screen
sleep 5;

echo "Starting roscore..."
if [[ $ROBOT_ID != "rbkairos" ]]; then
  screen -S core -d -m roscore;
else
  screen -S core -dm bash -c 'LD_LIBRARY_PATH=/opt/ros/melodic/lib; roscore'; #Temporary fix
fi

sleep 5;


if [[ -z "${ROBOT_RUN_MAP_NAV_MANAGER}" ]]; then
  ROBOT_RUN_MAP_NAV_MANAGER=false
fi
if [[ -z "${ROBOT_RUN_ROBOT_LOCAL_CONTROL}" ]]; then
  ROBOT_RUN_ROBOT_LOCAL_CONTROL=false
fi
if [[ -z "${ROBOT_RUN_PERCEPTION}" ]]; then
  ROBOT_RUN_PERCEPTION=false
fi
if [[ -z "${ROBOT_RUN_NAVIGATION}" ]]; then
  ROBOT_RUN_NAVIGATION=false
fi
if [[ -z "${ROBOT_RUN_HMI}" ]]; then
  ROBOT_RUN_HMI=false
fi
if [[ -z "${ROBOT_RUN_RLC_ROSTFUL_SERVER}" ]]; then
  ROBOT_RUN_RLC_ROSTFUL_SERVER=false
fi
if [[ -z "${ROBOT_HAS_ARM}" ]]; then
  ROBOT_HAS_ARM=false
fi


echo "RUN MAP_NAV_MANAGER = $ROBOT_RUN_MAP_NAV_MANAGER"
echo "RUN RLC = $ROBOT_RUN_ROBOT_LOCAL_CONTROL"
echo "RUN PERCEPTION = $ROBOT_RUN_PERCEPTION"
echo "RUN NAVIGATION = $ROBOT_RUN_NAVIGATION"
echo "RUN LOCALIZATION = $ROBOT_RUN_LOCALIZATION"
echo "RUN HMI = $ROBOT_RUN_HMI"
echo "RUN ROSTFUL SERVER = $ROBOT_RUN_RLC_ROSTFUL_SERVER"
echo "RUN ARM = $ROBOT_HAS_ARM"


sleep 2;
echo "Launching bringup..."
if [[ $ROBOT_ID != "rbkairos" ]]; then
  # screen -S bringup -d -m roslaunch summit_xl_bringup robot_complete.launch;
  screen -S bringup -dm bash -c 'LD_LIBRARY_PATH=/opt/ros/melodic/lib; source /opt/ros/melodic/setup.bash; source ~/ros/robotnik_common_ws/devel/setup.bash; mon launch summit_xl_bringup robot_complete.launch';
else
  # screen -S bringup -dm bash -c 'LD_LIBRARY_PATH=/opt/ros/melodic/lib; roslaunch summit_xl_bringup robot_complete.launch'; #Temporary fix
  screen -S bringup -dm bash -c 'LD_LIBRARY_PATH=/opt/ros/melodic/lib; source /opt/ros/melodic/setup.bash; source ~/ros/robotnik_common_ws/devel/setup.bash; mon launch summit_xl_bringup robot_complete.launch';
  sleep 15;
fi

sleep 5;

if $ROBOT_RUN_MAP_NAV_MANAGER
then
  echo "Launching map nav manager..."
  screen -S map_nav_manager -d -m roslaunch summit_xl_bringup map_nav_manager.launch;
  sleep 2;
fi


if $ROBOT_RUN_ROBOT_LOCAL_CONTROL
then
  echo "Launching robot local control..."
  screen -S control -d -m roslaunch summit_xl_robot_local_control robot_local_control.launch;
  sleep 2;
fi


if $ROBOT_RUN_PERCEPTION
then
  echo "Launching perception..."
  screen -S perception -d -m roslaunch summit_xl_perception perception_complete.launch;	
  sleep 1;
fi


if $ROBOT_RUN_NAVIGATION
then
  echo "Launching navigation..."
  screen -S navigation -d -m roslaunch summit_xl_navigation navigation_complete.launch;	
fi


if $ROBOT_RUN_HMI
then
  echo "Launching hmi packages..."
  screen -S robotnik_hmi -d -m roslaunch robotnik_hmi robotnik_hmi.launch;
  sleep 2;
fi

sleep 2;

if $ROBOT_RUN_RLC_ROSTFUL_SERVER
then
  echo "Launching hmi packages..."
  screen -S rlc_rostful_server -d -m roslaunch summit_xl_robot_local_control rostful_server.launch;
  sleep 1;
fi


if $ROBOT_HAS_ARM
then
  echo "Launching arm..."
  screen -S arm_bringup -d -m roslaunch summit_xl_bringup arm_complete.launch;
  sleep 2;
fi



