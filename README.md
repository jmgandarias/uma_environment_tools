# uma_environment_tools-
Set of tools to install, update and use the uma environment

This repo offers a variety of scripts that can be useful to interact with ROS, catkin, git, and other programming tools.

# Table of Contents


1.  [UMA environment](#1-uma-environment)
    1. [install_uma_environment](#11-install_uma_environment)
    2. [UMA tree](#12-uma-tree)
    3. [update_uma_environment](#13-update_uma_environment)
<!-- 2. [Catkin ws](#2-catkin-ws)
    1. [create_catkin_ws](#21-create_catkin_ws)
    2. [change_ros_ws](#22-change_ros_ws)
3. [Git](#3-git)
    1. [git_status_all](#31-git_status_all)
    2. [git_pull_all](#32-git_pull_all)
    3. [git_export_repos](#33-git_export_repos)
    4. [git_import_repos](#34-git_import_repos)
    5. [git_clone](#35-git_clone)
    6. [git_user_change](#36-git_user_change) -->

# 1. UMA environment

### 1.1 install_uma_environment
This script creates the uma environment, cloning the github repositories the user has access to into the UMA tree.  
Usage:  
```bash
cd /path/to/uma_installation_tools/scripts
./install_uma_environment.sh
```

### 1.2 UMA tree
The last script you run above created in your home folder the following folder tree:

```
.
│
├── personal
│   └── your personal repos (e.g., your website)
├── uma_environment
│       ├── uma_environment_tools
│       ├── uma_utils
│       ├── matlogger2
│       └── ...
├── ros
│    ├── my_ros2_ws
|    │   ├── src
|    │   ├── install
|    │   └── build
│    └── ...
|       
├── log
│   ├── my_logged_data__YYYY_MM_DD__HH_MM_SS.mat
│   └── ...
│
└── .uma_params.env

```

The structure above represents the UMA environment directory tree, subdivided in 4 main parts:
- **git**: in this folder you can find a local mirror of a few repos of the robotics_and_mechatronics_github group. These folders are needed to run the uma scripts and to build the necessary libraries. While you should not modify the structure of this tree, you can clone to the git folder other repositories of your interests.
- **ros**: this folder hosts the workspaces the user will create.
- **log**: here is the place where all the controller loggers are going to be saved.
- **.uma_params.env**: this [hidden file](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory) is the only file you should modify thourgh the command _modify_uma_params_. It contains the user preferences that will be reflected in all the UMA environment. Example:
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
This script updates [UMA tree](#12-uma-tree) with the github repositories the user has access to.  
Usage:  
```bash
update_uma_environment
```

# 2. Catkin ws

### 2.1 create_catkin_ws
This script guides you to the creation of a new catkin workspace, the catkin build type (make or build) is retrieved from the config file stored in _~/.uma_params.env_.  
Usage:  
```bash
create_catkin_ws
```

### 2.2 change_ros_ws
This script provides an easy way to switch from one workspace to another.  
Usage:  
```bash
change_ros_ws
#Note that you can also use the alias 'crw'
```
<!-- 
# 3. Git
Performing daily operations with many git repositories can lead to potential mistakes due to human errors, as forgetting to commit/push some of your important files. Here you are a list of command you can run after having installed the _hrii_environment_.
To run this scripts, you do not need to look for them inside this repos' folder, instead we created an alias for you and you just need to type the following commands in your teminal.

### 3.1 git_status_all
This script checks the status of all the repositories within the sourced catkin_ws, allowing you to commit and push unstaged changes.
```bash
user@workstation:~$ git_status_all
Checking in folder: /home/user/ros/my_catkin_ws/src

                      |------------------------|
                      |                        |
                      |          UMA          |
                      |       GIT STATUS       |
                      |                        |
                      |------------------------|

        Current git user: Name Surname (name.surname@iit.it).
                To change it, use the git_user_change script
--------------------------------------------------------------------------
hrii_dummy_fsm (noetic-devel) --> Modified files. Open Git GUI? [Y/n]
USER INPUT REQUIRED
--------------------------------------------------------------------------
hrii_franka (noetic-devel) --> nothing to commit.
--------------------------------------------------------------------------
hrii_robot_controllers (HEAD detached) --> nothing to commit.
--------------------------------------------------------------------------
hrii_robot_interface (noetic-plugin-architecture) --> nothing to commit.
--------------------------------------------------------------------------
hrii_robot_msgs (noetic-devel) -->  Added files. Open Git GUI? [Y/n]
USER INPUT REQUIRED
--------------------------------------------------------------------------
hrii_trajectory_planner (noetic-devel) --> nothing to commit.
However, your branch is ahead of 'origin/noetic-devel' by 1 commit.
Would you like to push? [Y/n]
USER INPUT REQUIRED
--------------------------------------------------------------------------
hrii_utils (noetic-devel) --> Deleted files. Open Git GUI?
USER INPUT REQUIRED
--------------------------------------------------------------------------
```

### 3.2 git_pull_all
This script pulls all the repositories (with no untracked changes) within the sourced catkin_ws.
```bash
user@workstation:~$ git_pull_all
Checking in folder: /home/user/ros/my_catkin_ws/src

                      |------------------------|
                      |                        |
                      |          UMA          |
                      |        GIT PULL        |
                      |                        |
                      |------------------------|


--------------------------------------------------------------------------
hrii_dummy_fsm (noetic-devel) --> up-to-date.
--------------------------------------------------------------------------
hrii_franka (noetic-devel) --> up-to-date.
--------------------------------------------------------------------------
hrii_robot_controllers (HEAD detached) --> cannot be pulled (HEAD detached).
--------------------------------------------------------------------------
hrii_robot_interface (noetic-plugin-architecture) --> up-to-date.
--------------------------------------------------------------------------
hrii_robot_msgs (noetic-devel) --> cannot be pulled safely (untracked files).
--------------------------------------------------------------------------
hrii_trajectory_planner (noetic-devel) --> cannot be pulled safely (modified files).
--------------------------------------------------------------------------
hrii_utils (noetic-devel) --> up-to-date.
--------------------------------------------------------------------------
```

### 3.3 git_export_repos
This script stores the git remote url of the repositories in the currently sourced workspace in a config file. The best place to run it is inside a config folder in your project.
 
The config file format is defined as:  
```bash
PROJECT
repo_url: branch
DEPENDENCIES
repo_url: branch (commit)
```
Usage:
```bash
user@workstation:~/ros/my_catkin_ws/src/hrii_my_project/config(noetic-devel)$ git_export_repos 
/home/user/ros/my_catkin_ws workspace sourced.
Checking in folder: /home/user/ros/my_catkin_ws/src
Creating config file in current folder: /home/user/ros/my_catkin_ws/src/hrii_my_project/config/ws_repos.yaml
git@gitlab.iit.it:hrii/robotics/franka/hrii_franka.git: noetic-devel (99e0847)
git@gitlab.iit.it:hrii/robotics/common/hrii_my_project.git: noetic-devel (project repo)
git@gitlab.iit.it:hrii/robotics/common/hrii_robot_controllers.git: noetic-devel (eda758d)
git@gitlab.iit.it:hrii/robotics/common/hrii_robot_interface.git: noetic-devel (eda8939)
git@gitlab.iit.it:hrii/robotics/common/hrii_robot_msgs.git: noetic-devel (d3f508b)
git@gitlab.iit.it:hrii/planning/hrii_trajectory_planner.git: noetic-devel (bb394eb)
git@gitlab.iit.it:hrii/general/hrii_utils.git: noetic-devel (744a2d7)
```

### 3.4 git_import_repos
Strictly connected to the previous command, this script clones the git repos listed in the config file provided as input, in the currently sourced workspace. It is usually used to import a series of repos that have been exported from a workspace with the [git_export_repos](#git_export_repos) command.  
The config file format given as input must be defined as:
```bash
PROJECT
repo_url: branch
DEPENDENCIES
repo_url: branch (commit)
```
Usage:
```bash
cd /path/to/config_file
git_import_repos config_file.yaml
```
Example:
```bash
user@workstation:~/git/hrii_gitlab/robotics/common/hrii_dummy_fsm/config(noetic-devel)$ git_import_repos dummy_fixed_manipulator_repos.yaml
input: dummy_fixed_manipulator_repos.yaml
config file: dummy_fixed_manipulator_repos.yaml
Checking WS: /home/user/ros/my_catkin_ws
Checking in folder: /home/user/ros/my_catkin_ws/src

                      |------------------------|
                      |                        |
                      |          UMA          |
                      |       GIT STATUS       |
                      |                        |
                      |------------------------|

        Current git user: Name Surname (name.surname@iit.it).
                To change it, use the git_user_change script
--------------------------------------------------------------------------
hrii_my_old_repo (noetic-devel) --> nothing to commit.
--------------------------------------------------------------------------

Workspace clean, moving (possibly) existing repos in /tmp/ws_2021-12-14_10_13_45 and checking out the repositories listed in:
/home/user/git/hrii_gitlab/robotics/common/hrii_dummy_fsm/config/dummy_fixed_manipulator_repos.yaml

git@gitlab.iit.it:hrii/robotics/common/hrii_dummy_fsm.git: noetic-devel (6145c4f)
git@gitlab.iit.it:hrii/robotics/franka/hrii_franka.git: noetic-devel (486096e)
git@gitlab.iit.it:hrii/robotics/common/hrii_robot_controllers.git: noetic-devel (f7ff377)
git@gitlab.iit.it:hrii/robotics/common/hrii_robot_interface.git: noetic-devel (710f8f3)
git@gitlab.iit.it:hrii/robotics/common/hrii_robot_msgs.git: noetic-devel (6bce8a8)
git@gitlab.iit.it:hrii/planning/hrii_trajectory_planner.git: noetic-devel (5e7cb07)
git@gitlab.iit.it:hrii/general/hrii_utils.git: noetic-devel (370b09d)

Cleaning workspace directory...
renamed 'hrii_my_old_repo' -> '/tmp/ws_2021-12-14_10_18_06/hrii_my_old_repo'
--------------------------------------------------------------------------
Repo: hrii_dummy_fsm | url: git@gitlab.iit.it:hrii/robotics/common/hrii_dummy_fsm.git | branch: noetic-devel | commit: 6145c4f
Cloning into 'hrii_dummy_fsm'...
Repo: hrii_robot_msgs | url: git@gitlab.iit.it:hrii/robotics/common/hrii_robot_msgs.git | branch: noetic-devel | commit: 6bce8a8
Cloning into 'hrii_robot_msgs'...
Repo: hrii_franka | url: git@gitlab.iit.it:hrii/robotics/franka/hrii_franka.git | branch: noetic-devel | commit: 486096e
Cloning into 'hrii_franka'...
Repo: hrii_robot_controllers | url: git@gitlab.iit.it:hrii/robotics/common/hrii_robot_controllers.git | branch: noetic-devel | commit: f7ff377
Cloning into 'hrii_robot_controllers'...
Repo: hrii_robot_interface | url: git@gitlab.iit.it:hrii/robotics/common/hrii_robot_interface.git | branch: noetic-devel | commit: 710f8f3
Cloning into 'hrii_robot_interface'...
Repo: hrii_trajectory_planner | url: git@gitlab.iit.it:hrii/planning/hrii_trajectory_planner.git | branch: noetic-devel | commit: 5e7cb07
Cloning into 'hrii_trajectory_planner'...
Repo: hrii_utils | url: git@gitlab.iit.it:hrii/general/hrii_utils.git | branch: noetic-devel | commit: 370b09d
Cloning into 'hrii_utils'...
```

Optional: you can checkout to the specific config file commits by running the command:
```bash
git_import_repos -cc #or  git_import_repos --commit_checkout
```

### 3.5 git_clone
This script allows to clone one of the repositories of the [UMA tree](#12-hrii-tree) in a simple manner. Just append the tree path or press tab to find the project you want to clone.  
Example, output shown by pressing tab after giving _general_ as input:
```bash
user@workstation:~$ git_clone general/
general/gitlab_ci_example.git        general/hrii_gazebo_utils.git        general/matlogger2.git               
general/how_to_do_it.git             general/hrii_installation_tools.git  general/nimbro_network.git           
general/hrii_arduino.git             general/hrii_utils.git               general/rbdl.git
```
```bash
user@workstation:~$ git_clone general/hrii_utils.git 
Cloning into 'hrii_utils'...
remote: Enumerating objects: 1410, done.
remote: Counting objects: 100% (45/45), done.
remote: Compressing objects: 100% (24/24), done.
remote: Total 1410 (delta 21), reused 45 (delta 21), pack-reused 1365
Receiving objects: 100% (1410/1410), 1.30 MiB | 778.00 KiB/s, done.
Resolving deltas: 100% (784/784), done.
```

### 3.6 git_user_change
This script allows to change the git user settings on your machine. Run it by entering:  
```bash
git_user_change
```
To directly set you name and email you can use this option:
```bash
git_user_change --name "Name Surname" --email "name.surname@iit.it"
```
To unset the git user from you machine, run:  
```bash
git_user_change --unset
```


## Use it

From windows terminal:
```
wsl 
```

```bash
sudo apt update
sudo apt upgrade
git clone https://github.com/jmgandarias/uma_environment_tools.git
cd uma_environment_tools/scripts
./install_uma_environment.sh
```


