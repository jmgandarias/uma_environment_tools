#!/bin/bash
# UMA parameters selection script
#
# Author: Juan M. Gandarias
# email: jmgandarias@uma.es
#
# Thanks to the support of the HRII Technicians
#

source $HOME/git/uma_environment_tools/uma_installation_tools/scripts/utils.sh
source $HOME/.uma_params.env

# default values
verbosity=$(echo $UMA_ENV_VERBOSITY) #true/false
git_client=$(echo $GIT_CLIENT) #GUI/kraken
terminal_style=$(echo $TERMINAL_COLORS) #1/2
interface_type=$(echo ${INTERFACE_TYPE,,}) #simulation/hardware - converting to lower case
arm_ip=$(echo $ROBOT_ARM_IP)

ros_version=$(echo $ROS_DISTRO_TO_SOURCE) #noetic/foxy
catkin_build_type=$(echo $CATKIN_BUILD_TYPE) #build/make
remote_master=$(echo $ROS_REMOTE_MASTER) #false/true
master_ip=$(echo $ROS_MASTER_IP)
my_ip=$(echo $MY_IP)
sourced_catkin_ws=$(echo "$WORKSPACE_TO_SOURCE" | sed "s#"$HOME"#~#")
error=1

max_size=${#sourced_catkin_ws}
((windows_size=max_size+35))

# open fd
exec 3>&1

# Main loop
while [ $error = 1 ]; do
	#Reset error flag
	error=0

	# Store data to $VALUES variable
	VALUES=$(dialog --ok-label "Save" \
		  --backtitle "UMA params management" \
		  --title "UMA parameters selection" \
		  --form "Select your desired UMA params:"       20 $windows_size 0 \
			"Verbosity:"        1 1	 "$verbosity"          1 17 $max_size 0  \
			"Git client:"       2 1	 "$git_client"          2 17 $max_size 0  \
			"Terminal style:"   3 1	 "$terminal_style"     3 17 $max_size 0 \
			"Interface:"        4 1  "$interface_type"     4 17 $max_size 0 \
			"Arm IP"            5 1	 "$arm_ip"    		   5 17 $max_size 0 \
			"ROS"               7 1	 ""    				   7 0 0 0 \
			"Distro:"           8 1	 "$ros_version"        8 17 $max_size 0 \
			"Catkin build:"     9 1	 "$catkin_build_type"  9 17 $max_size 0 \
			"Remote master:"   10 1	 "$remote_master"     10 17 $max_size 0 \
			"Master IP:"       11 1	 "$master_ip"         11 17 $max_size 0 \
			"My IP:"           12 1	 "$my_ip"             12 17 $max_size 0 \
			"Catkin ws:"       13 1  "$sourced_catkin_ws" 13 17 0 0 \
	2>&1 1>&3)
	exitStatus=$? # 0: save - 1: cancel

	if [ $exitStatus = 1 ]; then
		break;
	fi
		
	fields=($VALUES)

	if [ ${#fields[@]} -ne 10 ]; then
		display_mgs="One or more fields were not set, please fill in all the entries."
		error=1
		dialog --title Error --msgbox "$display_mgs" 10 50
	else
		verbosity=${fields[0]}
		git_client=${fields[1]}
		terminal_style=${fields[2]}
		interface_type=${fields[3]}
		arm_ip=${fields[4]}
		ros_version=${fields[5]}
		catkin_build_type=${fields[6]}
		remote_master=${fields[7]}
		master_ip=${fields[8]}
		my_ip=${fields[9]}

		# Verbosity field check
		if [ $verbosity = "true" ] || [ $verbosity = "false" ]; then
			: #echo "ok"
			# Git client field check
			if [ $git_client = "GUI" ] || [ $git_client = "kraken" ]; then
				: #echo "ok"
				# ROS version field check
				if [ $ros_version = "noetic" ] || [ $ros_version = "foxy" ] || [ $ros_version = "none" ]; then
					: #echo "ok"
					# Terminal style field check
					if [ $terminal_style = "style_1" ] || [ $terminal_style = "style_2" ]; then
						: #echo "ok"
						# Interface type field check
						if [ $interface_type = "simulation" ] || [ $interface_type = "hardware" ]; then
							: #echo "ok"
							# Catkin build type field check
							if [ $catkin_build_type = "build" ] || [ $catkin_build_type = "make" ]; then
								: #echo "ok"
								# Remote master field check
								if [ $remote_master = "false" ] || [ $remote_master = "true" ]; then
									: #echo "ok"
								else
									display_mgs="\"Remote master\" value not admitted. Please select between \"false\" and \"true\"!"
									error=1
									dialog --title Error --msgbox "$display_mgs" 10 50
								fi
							else
								display_mgs="\"Catkin\" value not admitted. Please select between \"build\" and \"make\"!"
								error=1
								dialog --title Error --msgbox "$display_mgs" 10 50
							fi
						else
							display_mgs="\"Interface\" value not admitted. Please select between \"simulation\" and \"hardware\"!"
							error=1
							dialog --title Error --msgbox "$display_mgs" 10 50
						fi
					else
						display_mgs="\"Terminal style\" value not admitted. Please select between \"style_1\" and \"style_2\"!"
						error=1
						dialog --title Error --msgbox "$display_mgs" 10 50
					fi
				else
					display_mgs="\"ROS version\" value not admitted. Please select between \"none\", \"noetic\" and \"foxy\"!"
					error=1
					dialog --title Error --msgbox "$display_mgs" 10 50
				fi
			else
				display_mgs="\"Git client\" value not admitted. Please select between \"GUI\" and \"kraken\"!"
				error=1
				dialog --title Error --msgbox "$display_mgs" 10 50
			fi
		else
			display_mgs="\"Verbosity\" value not admitted. Please select between \"true\" and \"false\"!"
			error=1
			dialog --title Error --msgbox "$display_mgs" 10 50
		fi
	fi
done

# close fd
exec 3>&-

# display values just entered
# echo "$VALUES"

clear

if [ $exitStatus = 1 ]; then
	warn "UMA params not configured"
else
	# susbtitute values in .uma_params.env
	verbosity=${fields[0]}
	git_client=${fields[1]}
	terminal_style=${fields[2]}
	interface_type=$(echo ${fields[3]^^}) # convert to UPPER case
	arm_ip=${fields[4]}
	ros_version=${fields[5]}
	catkin_build_type=${fields[6]}
	remote_master=${fields[7]}
	master_ip=${fields[8]}
	my_ip=${fields[9]}

	sed -i 's/UMA_ENV_VERBOSITY=[0-9a-zA-Z_~/-]*/UMA_ENV_VERBOSITY='$verbosity'/' ~/.uma_params.env
	sed -i 's/GIT_CLIENT=[0-9a-zA-Z_~/-]*/GIT_CLIENT='$git_client'/' ~/.uma_params.env
	sed -i 's/TERMINAL_COLORS=[0-9a-zA-Z_~/-]*/TERMINAL_COLORS='$terminal_style'/' ~/.uma_params.env
	sed -i 's/INTERFACE_TYPE=[0-9a-zA-Z_~/-]*/INTERFACE_TYPE='$interface_type'/' ~/.uma_params.env
	sed -i 's/ROBOT_ARM_IP=[0-9.]*/ROBOT_ARM_IP='$arm_ip'/' ~/.uma_params.env
	sed -i 's/ROS_DISTRO_TO_SOURCE=[0-9a-zA-Z_~/-]*/ROS_DISTRO_TO_SOURCE='$ros_version'/' ~/.uma_params.env
	sed -i 's/CATKIN_BUILD_TYPE=[0-9a-zA-Z_~/-]*/CATKIN_BUILD_TYPE='$catkin_build_type'/' ~/.uma_params.env
	sed -i 's/ROS_REMOTE_MASTER=[0-9a-zA-Z_~/-]*/ROS_REMOTE_MASTER='$remote_master'/' ~/.uma_params.env
	sed -i 's/ROS_MASTER_IP=[0-9.]*/ROS_MASTER_IP='$master_ip'/' ~/.uma_params.env
	sed -i 's/MY_IP=[0-9.]*/MY_IP='$my_ip'/' ~/.uma_params.env
	reset; . ~/.bashrc
	success "UMA params configured successfully stored"
fi
