#!/bin/bash

# gazebo aliases
alias gazebo_unpause_physics='rosservice call /gazebo/unpause_physics'
alias gazebo_pause_physics='rosservice call /gazebo/pause_physics'
alias gazebo_kill='killall -9 gzserver; killall -9 gzclient'

# catkin and workspace aliases
# CMAKE_LIBFRANKA_DIR='-DFranka_DIR:PATH='$HOME'/git/hrii_gitlab/robotics/franka/libfranka/build'
# CMAKE_MATLOGGER2_DIR='-Dmatlogger2_DIR='$HOME'/git/hrii_gitlab/general/matlogger2/build'
# CMAKE_MATLOGGER2_ADVR_DIR='-Dmatlogger2_DIR='$HOME'/git/MatLogger2/build'
# CMAKE_OPENPOSE_DIR='-DOpenPose_DIR='$HOME'/git/openpose/build/cmake'
# CMAKE_REALSENSE_DIR='-Drealsense2_DIR='$HOME'/git/librealsense/lib/cmake/realsense2/'
# CMAKE_SIMBODY_DIR='-DSimbody_DIR:PATH='$HOME'/.local/simbody/lib/cmake/simbody'
# CMAKE_OPENSIM_DIR='-DOpenSim_DIR:PATH='$HOME'/.local/opensim-core/lib/cmake/OpenSim'
# CMAKE_RTOSIM_DIR='-DRTOSIM_DIR:PATH='$HOME'/.local/rtosim/lib/RTOSIM'
# CMAKE_CONCURRENCY_DIR='-DConcurrency_DIR:PATH='$HOME'/.local/Concurrency/lib/Concurrency'
# CMAKE_QBROBOTICS_DRIVER_DIR='-Dqbrobotics_driver_DIR:PATH='$HOME'/git/hrii_gitlab/robotics/grippers/qbrobotics-api/qbrobotics-driver'
# CMAKE_SERIAL_DIR='-DSerial_DIR:PATH='$HOME'/git/hrii_gitlab/robotics/grippers/qbrobotics-api/serial'

# ROS and WS aliases
alias source_ros='source /opt/ros/$ROS_DISTRO_TO_INSTALL/setup.bash'
alias source_ros2='source /opt/ros/$ROS2_DISTRO_TO_INSTALL/setup.bash'

alias cd_ws='cd $WORKSPACE_TO_SOURCE'
if [ $ROS_VERSION == 1 ]; then
    alias cb='reset && catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release'
    alias cb_debug='reset && catkin build --cmake-args -DCMAKE_BUILD_TYPE=Debug'
    alias cc='catkin clean --yes'
    alias ct='reset && catkin run_tests'
    # alias cb_libfranka='reset && catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_LIBFRANKA_DIR $CMAKE_MATLOGGER2_DIR'
    # alias cm_libfranka='reset && catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_LIBFRANKA_DIR $CMAKE_MATLOGGER2_DIR'
    # alias cb_matlogger2='reset && catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_MATLOGGER2_DIR'
    # alias cm_matlogger2='reset && catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_MATLOGGER2_DIR'
    # alias cb_matlogger2_advr='reset && catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_MATLOGGER2_ADVR_DIR'
    # alias cm_matlogger2_advr='reset && catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_MATLOGGER2_ADVR_DIR'
    alias cm='reset && catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release'
    alias cdcm='cd $WORKSPACE_TO_SOURCE && cm_libfranka'
    alias cdcb='cd $WORKSPACE_TO_SOURCE && cb_libfranka'
    # alias cm_openpose='reset && catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_OPENPOSE_DIR'
    # alias cb_openpose='reset && catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_OPENPOSE_DIR'
    # alias cm_realsense='reset && catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_REALSENSE_DIR'
    # alias cb_realsense='reset && catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_REALSENSE_DIR'
    # alias cb_opensim='reset && catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_OPENSIM_DIR $CMAKE_SIMBODY_DIR'
    # alias cb_rtosim='reset && catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_OPENSIM_DIR $CMAKE_SIMBODY_DIR $CMAKE_CONCURRENCY_DIR $CMAKE_RTOSIM_DIR'
    alias cb_full='reset && catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_MATLOGGER2_DIR $CMAKE_LIBFRANKA_DIR $CMAKE_OPENPOSE_DIR $CMAKE_QBROBOTICS_DRIVER_DIR $CMAKE_SERIAL_DIR'
    alias cm_full='reset && catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_MATLOGGER2_DIR $CMAKE_LIBFRANKA_DIR $CMAKE_OPENPOSE_DIR $CMAKE_QBROBOTICS_DRIVER_DIR $CMAKE_SERIAL_DIR'
    # alias cb_softhand='reset && catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_QBROBOTICS_DRIVER_DIR $CMAKE_SERIAL_DIR'
    # alias cm_softhand='reset && catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release $CMAKE_QBROBOTICS_DRIVER_DIR $CMAKE_SERIAL_DIR'

    # ROS aliases
    alias rosdep_src_install='rosdep install --from-paths src --ignore-src --rosdistro $ROS_DISTRO -y --skip-keys libfranka'
    alias ros_kill='killall -9 roscore; killall -9 rosmaster'
    alias ros_view_frames='rosrun tf2_tools view_frames.py; xdg-open frames.pdf'
fi

if [ $ROS_VERSION == 2 ]; then
    alias cb='reset && colcon build --symlink-install'
    alias ct='reset && colcon test'
    alias cc='echo "Removing build install log folders in $WORKSPACE_TO_SOURCE..."; rm -r $WORKSPACE_TO_SOURCE/build $WORKSPACE_TO_SOURCE/install $WORKSPACE_TO_SOURCE/log'
    alias rosdep_src_install='rosdep install -i --from-path src --rosdistro $ROS_DISTRO -y --skip-keys libfranka'
fi

# git aliases
alias git_status_all='. $HOME/uma_environment/uma_environment_tools/scripts/git/git_status_all.sh'
alias git_pull_all='. $HOME/uma_environment/uma_environment_tools/scripts/git_pull_all.sh'
alias git_export_repos='. $HOME/uma_environment/uma_environment_tools/scripts/git_export_repos.sh'
alias git_import_repos='. $HOME/uma_environment/uma_environment_tools/scripts/git_import_repos.sh'
alias git_clone='. $HOME/uma_environment/uma_environment_tools/scripts/git_clone.sh'
alias git_user_change='. $HOME/uma_environment/uma_environment_tools/scripts/git_user_change.sh'

# UMA environment
alias update_uma_environment='. $HOME/uma_environment/uma_environment_tools/scripts/install_uma_environment.sh'

# General aliases
alias nt='reset; . ~/.bashrc'
alias crw='. $HOME/uma_environment/uma_environment_tools/scripts/ros/change_ros_ws.sh'
alias crv='. $HOME/uma_environment/uma_environment_tools/scripts/ros/change_ros_version.sh'
alias create_catkin_ws='. $HOME/uma_environment/uma_environment_tools/scripts/create_catkin_ws.sh'
alias modify_bashrc='gedit ~/.bashrc'
alias modify_uma_params='. $HOME/uma_environment/uma_environment_tools/scripts/uma_params_menu.sh'
alias sd='sudo shutdown now'
alias reboot='sudo reboot'
alias start_vnc_server='x11vnc -display :0'
alias compress_pdf='gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=compressed_pdf.pdf'
reboot_to_windows () {
   windows_title=$(grep -i windows /boot/grub/grub.cfg | cut -d "'" -f 2)
   sudo grub-reboot "$windows_title" && sudo reboot
}
alias reboot_to_windows='reboot_to_windows'

# Logging and plot data aliases
alias plot_data='python3 $HOME/git/hrii_gitlab/general/_utils/scripts/plot_logged_data.py'
alias delete_mat_files='find . -name "*.mat" -type f -delete'

# Summit XLS aliases
# MOCA_RED_IP=192.168.1.200
# MOCA_WHITE_IP=192.168.2.200
# RB_KAIROS_IP=192.168.3.200
# R4M_RB_KAIROS_IP=192.168.4.200


# alias moca_red='ssh -X summit@$MOCA_RED_IP'
# alias moca_white='ssh -X summit@$MOCA_WHITE_IP'
# alias rb_kairos='ssh -X summit@$RB_KAIROS_IP'
# alias r4m_rb_kairos='ssh -X summit@$R4M_RB_KAIROS_IP'

# alias moca_red_terminator='terminator -p moca_red'
# alias moca_white_terminator='terminator -p moca_white'
# alias rb_kairos_terminator='terminator -p rb_kairos'
# alias r4m_rb_kairos_terminator='terminator -p r4m_rb_kairos'

# alias moca_red_nautilus='nautilus sftp://summit@$MOCA_RED_IP/home/summit'
# alias moca_white_nautilus='nautilus sftp://summit@$MOCA_WHITE_IP/home/summit'
# alias rb_kairos_nautilus='nautilus sftp://summit@$RB_KAIROS_IP/home/summit'
# alias r4m_rb_kairos_nautilus='nautilus sftp://summit@$R4M_RB_KAIROS_IP/home/summit'

# alias moca_red_ip='echo $MOCA_RED_IP'
# alias moca_white_ip='echo $MOCA_WHITE_IP'
# alias rb_kairos_ip='echo $RB_KAIROS_IP'
# alias r4m_rb_kairos_ip='echo $R4M_RB_KAIROS_IP'
# alias r4m_rb_kairos_ip='echo $JETSON_ORIN_IP'

# alias reset_odom='rosservice call /$ROBOT_ID/set_odometry "x: 0.0
# y: 0.0
# z: 0.0
# orientation: 0.0"'


# Demos
# alias teleop_twist_keyboard='ROS_NAMESPACE=$ROBOT_ID rosrun hrii_utils teleop_twist_keyboard.py'
# alias mocaman='reset; reset_odom; roslaunch hrii_mocaman_launcher superman.launch'
# alias follow_me='roslaunch hrii_general_robot_controllers follow_me.launch robot_model:=franka launch_rviz:=false'
# alias wb_impedance_controller='roslaunch hrii_floating_base_robot_controllers wb_cartesian_impedance_controller.launch robot_model:=moca arm_model:=franka launch_rviz:=false'

# Franka aliases
alias franka_open_brakes='roscd hrii_franka_interface && python3 scripts/frankaOpenBrakes.py && cd -'
alias franka_close_brakes='roscd hrii_franka_interface && python3 scripts/frankaCloseBrakes.py && cd -'
alias franka_shut_down='roscd hrii_franka_interface && python3 scripts/frankaShutDown.py && cd -'
alias move_to_initial_pose='roslaunch hrii_franka_control move_to_target_joint_position.launch' #currently not working

# Network aliases
alias network_scan='sudo arp-scan --localnet'
alias ip="ip -c a | sed -n '/as0/q;p'"
alias internet_ping="ping 8.8.8.8"

# Docker aliases
# alias docker_clean_images='docker rmi $(docker images -a --filter=dangling=true -q)'
# alias docker_clean_ps='docker rm $(docker ps --filter=status=exited --filter=status=created -q)'
# alias docker_openvico='terminator -l docker_openvico_layout'
