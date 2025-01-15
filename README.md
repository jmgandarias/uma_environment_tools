# UMA Environment Tools
Set of tools to install, update and use the uma environment

This repo offers a variety of scripts that can be useful to interact with ROS, catkin, git, and other programming tools.

# Table of Contents

1.  [UMA environment](#1-uma-environment)
    1. [install_uma_environment](#11-install_uma_environment)
    2. [UMA tree](#12-uma-tree)
    3. [update_uma_environment](#13-update_uma_environment)
2. [Useful tools](#2-catkin-ws)
    1. [Terminator](#21-terminator)
    2. [create_catkin_ws](#22-create_catkin_ws)
    3. [change_ros_ws](#23-change_ros_ws)
    4. [create_ros2_pkg](#24-create_ros2_pkg)
    5. [nt](#24-nt)
    6. [cb](#24-cb)
    7. [cc](#24-cc)

# 1. UMA environment

### 1.1 Install UMA Environment
This script creates the uma environment, installing required packages and dependencies and creating an organization structure   

#### Using WSL?
From windows terminal:
```
wsl 
```

#### Once you're in Ubuntu system
From Ubuntu terminal:
```bash
sudo apt update
sudo apt upgrade
git clone https://github.com/jmgandarias/uma_environment_tools.git
cd uma_environment_tools/scripts
./install_uma_environment.sh
```

### 1.2 UMA Environment Organization
The last script you run above created in your home (`~/`) folder the following folder tree:

```
.
│
├── uma_environment_tools
│       ├── config
│       ├── README.md
│       └── scripts
├── ros
│    ├── my_first_ros2_ws
|    │   ├── build
|    │   ├── install
|    │   ├── log
|    │   └── src
|    |
│    ├── my_second_ros2_ws
|    │   ├── build
|    │   ├── install
|    │   ├── log
|    │   └── src
|    |
│    └── ...
|       
├── log
│   ├── my_logged_data__YYYY_MM_DD__HH_MM_SS.mat
│   └── ...
│
└── .uma_params.env

```

The structure above represents the UMA environment directory tree, subdivided in 4 main parts:
- **uma_environment_tools**: this folder contains the scripts and config files of the uma_environment_tools repo.
- **ros**: this folder hosts the workspaces the user will create.
- **log**: here is the place where you should save all your logged data.
- **.uma_params.env**: this [hidden file](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory) is the only file you can modify thourgh the command _modify_uma_params_. It contains the user preferences that will be reflected in all the UMA environment. Example:

```bash
#####################
# UMA PARAMS V.0.1 #
#####################

#Set your ENV variables preferences
UMA_ENV_VERBOSITY=true

#Set git client preferences (GUI/kraken)
GIT_CLIENT=kraken

#Set ROS distro
ROS2_DISTRO_TO_INSTALL=humble

#Set ROS distro (one between the two above)
ROS_DISTRO_TO_SOURCE=humble

#Set your workspace source
WORKSPACES_PATH=~/ros
export WORKSPACE_TO_SOURCE=$WORKSPACES_PATH/catkin_ws

#Set the terminal colors style (style_1/style_2)
TERMINAL_COLORS=style_2

#Set the interface type (SIMULATION/HARDWARE)
export INTERFACE_TYPE=SIMULATION

#Set the catkin building type (make/build)
CATKIN_BUILD_TYPE=build

```
To edit this file type:
```bash
modify_uma_params
```

### 1.3 update_uma_environment
This script (alias) updates the UMA environment.
Usage:  
```bash
update_uma_environment
```

# 2. Useful Tools

### 2.1 Terminator

### 2.2 create_catkin_ws
This script guides you to the creation of a new catkin workspace, the catkin build type (make or build) is retrieved from the config file stored in _~/.uma_params.env_.  
Usage:  
```bash
create_catkin_ws
```

### 2.3 change_ros_ws
This script provides an easy way to switch from one workspace to another.  
Usage:  
```bash
change_ros_ws
#Note that you can also use the alias 'crw'
```

### 2.4 create_ros2_pkg

### 2.5 nt

### 2.6 cb

### 2.7 cc

