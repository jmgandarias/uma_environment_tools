#!/bin/bash

# Set ROS Master and IP for ROS1
if [ $ROS_DISTRO_TO_SOURCE == 'noetic' ]; then
  # Workspace source
  if [ ! -f "$WORKSPACE_TO_SOURCE/devel/setup.bash" ]; then
    echo "$WORKSPACE_TO_SOURCE/devel/setup.bash not found. Failed sourcing the catkin workspace."
    # ROS source
    if [ ! -f "/opt/ros/$ROS_DISTRO_TO_SOURCE/setup.bash" ]; then
      echo "/opt/ros/$ROS_DISTRO_TO_SOURCE/setup.bash not found. Failed sourcing the ROS."
    else
      source /opt/ros/$ROS_DISTRO_TO_SOURCE/setup.bash
      if [ "$HRII_ENV_VERBOSITY" = true ]; then
        echo "Sourced workspace: none (ROS $ROS_DISTRO)"
      fi
    fi
  else
    source $WORKSPACE_TO_SOURCE/devel/setup.bash
    if [ "$HRII_ENV_VERBOSITY" = true ]; then
      echo "Sourced workspace: $WORKSPACE_TO_SOURCE (ROS $ROS_DISTRO)"
    fi
  fi
  # Set ROS_MASTER_URI/IP/HOSTNAME
  if [ $USER != "summit" ]; then
    if [ "$ROS_REMOTE_MASTER" = false ]; then
      export ROS_MASTER_URI=http://localhost:11311
      unset ROS_IP
      export ROS_HOSTNAME=localhost #if we unset like before, it may not be able to launch roscore
    else
      export ROS_MASTER_URI=http://$ROS_MASTER_IP:11311
      export ROS_IP=$MY_IP
      unset ROS_HOSTNAME
    fi
  fi
elif [ $ROS_DISTRO_TO_SOURCE == 'foxy' ]; then
  # Workspace source
  if [ ! -f "$WORKSPACE_TO_SOURCE/install/setup.bash" ]; then
    echo "$WORKSPACE_TO_SOURCE/install/setup.bash not found. Failed sourcing the colcon workspace."
    # ROS source
    if [ ! -f "/opt/ros/$ROS_DISTRO_TO_SOURCE/setup.bash" ]; then
      echo "/opt/ros/$ROS_DISTRO_TO_SOURCE/setup.bash not found. Failed sourcing the ROS."
    else
      source /opt/ros/$ROS_DISTRO_TO_SOURCE/setup.bash
      if [ "$HRII_ENV_VERBOSITY" = true ]; then
        echo "Sourced workspace: none (ROS $ROS_DISTRO)"
      fi
    fi
  else
    . $WORKSPACE_TO_SOURCE/install/setup.bash
    if [ "$HRII_ENV_VERBOSITY" = true ]; then
      echo "Sourced workspace: $WORKSPACE_TO_SOURCE (ROS $ROS_DISTRO)"
    fi
  fi
  # Setup colcon_cd
  source /usr/share/colcon_cd/function/colcon_cd.sh
  export _colcon_cd_root=/opt/ros/foxy/
  # Setup colcon tab completion
  source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

  export ROS_DOMAIN_ID=0
else
  export ROS_VERSION="none"
fi

# Change default ROS editor
export EDITOR='nano -w'
