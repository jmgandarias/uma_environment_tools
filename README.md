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

### 1.1. Install UMA Environment
Create the uma environment, installing required packages and dependencies and creating an organized structure   

#### Using WSL?
1. **Install WSL:**

- If you're running Windows 10 version 2004 and higher (Build 19041 and higher) or Windows 11, you can install everything you need to run WSL with a single command. Open PowerShell or Windows Command Prompt in administrator mode by right-clicking and selecting "Run as administrator", enter the following command:

    ```bash
    wsl --install
    ```

    After installing, restar yout machine.
- If you are on earlier versions please see the [manual install page](https://learn.microsoft.com/en-us/windows/wsl/install-manual) and follow the instructions.

2. **Install Ubuntu 22.04:**

    From windows terminal:
   
    ```bash
    wsl --install Ubuntu-22.04
    ```

    It will ask you for the username and password of the Ubuntu user. 
    If you're not familiar with Linux terminal, when it asks for your password, it doesn't show what you're writting. So don't think you're not writing, it just simply doesn't show it.

    ```
    Enter new UNIX username: <YOUR_USERNAME>
    New password:
    Retype new password:
    passwd: password updated successfully
    Installation successful! 
    ```
    This installation process will take some time and it will ask you for confirmation to install some packages and dependencies (you need to say ```yes``` to all).
    After this, you can just open an Ubuntu terminal by searching for Ubuntu in your Windows applications.

#### Once you're inside the Ubuntu system
From the Ubuntu terminal:
```bash
sudo apt update
sudo apt upgrade
git clone https://github.com/jmgandarias/uma_environment_tools.git
cd uma_environment_tools/scripts
./install_uma_environment.sh
```

If you find an error when installing python3-catkin-pkg during the installation, run the following command:
```bash
sudo apt --fix-broken install
```

After installing the UMA environment, you can close that terminal and open a new one.
By installing the UMA environment, you have installed Terminator (a specific Ubuntu terminal that will make your life easy).
To open an Ubuntu terminator from Windows you just have to look for it in your Windows applications.

The first thing you need to do is to update the uma environment to finish the installation. Run:

```bash
update_uma_environment
````

Now, restart the terminal by running the new terminal alias (nt):

```bash
nt
```

Then, you need to create a catkin workspace, to do so, run the following alias:

```bash
create_catkin_ws
```

It will create a catkin_ws inside the folder ros. Remember that the UMA environment expects that all the workspace names end with _ws (i.e., <MY_ROS2_WORKSPACE_NAME>_ws). 
The default name is catkin_ws. 

Once the workspace has been created, you need to compile it with colcon build, you can do it with the following alias:

```bash
cb
```

You should see that the workspace is automatically sourced. From now on, every new terminal you open will automatically source this workspace. 
Refer to  [create_catkin_ws](#22-create_catkin_ws) and [change_ros_ws](#23-change_ros_ws) if you want to create more workspaces and change the workspace to be sourced.


### 1.2. UMA Environment Organization
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

### 1.3. update_uma_environment
This script (alias) updates the UMA environment.
Usage:  
```bash
update_uma_environment
```

# 2. Useful Tools

### 2.1. Terminator

### 2.2. create_catkin_ws
This script guides you to the creation of a new catkin workspace, the catkin build type (make or build) is retrieved from the config file stored in _~/.uma_params.env_.  
Usage:  
```bash
create_catkin_ws
```

### 2.3. change_ros_ws
This script provides an easy way to switch from one workspace to another.  
Usage:  
```bash
change_ros_ws
#Note that you can also use the alias 'crw'
```

### 2.4. create_ros2_pkg

### 2.5. nt

### 2.6. cb

### 2.7. cc

