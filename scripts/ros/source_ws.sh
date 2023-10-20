#!/bin/bash

# ROS source
if [ ! -f "$WORKSPACE_TO_SOURCE/devel/setup.bash" ]; then
  echo "$WORKSPACE_TO_SOURCE/devel/setup.bash not found. Failed sourcing the catkin workspace."
else
  source $WORKSPACE_TO_SOURCE/devel/setup.bash
  if [ "$HRII_ENV_VERBOSITY" = true ]; then
    echo "Sourced workspace: $WORKSPACE_TO_SOURCE (ROS $ROS_DISTRO_TO_SOURCE)"
  fi
fi