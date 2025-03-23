#!/bin/bash

# gazebo aliases
alias gazebo_unpause_physics='rosservice call /gazebo/unpause_physics'
alias gazebo_pause_physics='rosservice call /gazebo/pause_physics'
alias gazebo_kill='killall -9 gzserver; killall -9 gzclient'

if [ $ROS_VERSION == 2 ]; then
    alias cdw='cd $WORKSPACE_TO_SOURCE'
    alias cb='reset && colcon build --symlink-install'
    alias ct='reset && colcon test'
    alias cc='echo "Removing build install log folders in $WORKSPACE_TO_SOURCE..."; rm -r $WORKSPACE_TO_SOURCE/build $WORKSPACE_TO_SOURCE/install $WORKSPACE_TO_SOURCE/log'
    alias rosdep_src_install='rosdep install -i --from-path src --rosdistro $ROS_DISTRO -y --skip-keys libfranka'
fi

# UMA environment
alias update_uma_environment='. $HOME/uma_environment_tools/scripts/install_uma_environment.sh'

# General aliases
alias nt='reset; . ~/.bashrc'
alias crw='. $HOME/uma_environment_tools/scripts/ros2/change_ros_ws.sh'
alias create_catkin_ws='. $HOME/uma_environment_tools/scripts/create_catkin_ws.sh'
alias create_ros2_pkg='. $HOME/uma_environment_tools/scripts/create_ros2_pkg.sh'
alias modify_bashrc='gedit ~/.bashrc'
alias modify_uma_params='. $HOME/uma_environment_tools/scripts/uma_params_menu.sh'
alias sd='sudo shutdown now'
alias reboot='sudo reboot'
alias start_vnc_server='x11vnc -display :0'
alias compress_pdf='gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=compressed_pdf.pdf'

# Plotjuggler
alias plotjuggler='ros2 run plotjuggler plotjuggler'
