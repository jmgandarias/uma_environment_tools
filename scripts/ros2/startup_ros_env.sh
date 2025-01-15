#!/bin/bash


if [ $ROS_DISTRO_TO_SOURCE == 'humble' ]; then
  # Workspace source
  if [ ! -f "$WORKSPACE_TO_SOURCE/install/setup.bash" ]; then
    echo "$WORKSPACE_TO_SOURCE/install/setup.bash not found. Failed sourcing the colcon workspace."
    # ROS source
    if [ ! -f "/opt/ros/$ROS_DISTRO_TO_SOURCE/setup.bash" ]; then
      echo "/opt/ros/$ROS_DISTRO_TO_SOURCE/setup.bash not found. Failed sourcing the ROS."
    else
      source /opt/ros/$ROS_DISTRO_TO_SOURCE/setup.bash
      if [ "$UMA_ENV_VERBOSITY" = true ]; then
        echo "Sourced workspace: none (ROS $ROS_DISTRO)"
      fi
    fi
  else
    . $WORKSPACE_TO_SOURCE/install/setup.bash
    if [ "$UMA_ENV_VERBOSITY" = true ]; then
      echo "Sourced workspace: $WORKSPACE_TO_SOURCE (ROS $ROS_DISTRO)"
    fi
  fi
  # Setup colcon_cd
  source /usr/share/colcon_cd/function/colcon_cd.sh
  export _colcon_cd_root=/opt/ros/humble/
  # Setup colcon tab completion
  source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

  export ROS_DOMAIN_ID=0
else
  export ROS_VERSION="none"
fi

# Change default ROS editor
export EDITOR='nano -w'
