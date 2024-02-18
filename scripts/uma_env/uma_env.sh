#!/bin/bash

source ~/.uma_params.env

source $HOME/uma_environment/uma_environment_tools/scripts/ros/startup_ros_env.sh
source $HOME/uma_environment/uma_environment_tools/scripts/uma_env/uma_aliases.sh
source $HOME/uma_environment/uma_environment_tools/scripts/git/git_user_check.sh
source $HOME/uma_environment/uma_environment_tools/scripts/github/create_github_dir.sh

# Add PATH export to include pymodbus and pyserial scripts
export PATH="$PATH:/home/$USER/.local/bin"

# Add LD_LIBRARY_PATH export to include matlogger2 for python
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/uma_environment_tools/matlogger2/build"

# adding colors and names to git branches
force_color_prompt=yes
color_prompt=yes
parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
if [ "$color_prompt" = yes ]; then
  if [ "$TERMINAL_COLORS" = "style_1" ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
  elif [ "$TERMINAL_COLORS" = "style_2" ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[1;31m\]\u\[\033[1;37m\]@\[\033[1;32m\]\h\[\033[1;37m\]:\[\033[1;36m\]\w \[\033[1;35m\]$(parse_git_branch) \[\033[1;33m\]\$ \[\033[0m\]'
  fi
else
 PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
fi
unset color_prompt force_color_prompt

# Add autocompletion in bash command umacd
UMA_GITHUB_REPOS_TO_COMPLETE=""
for REPO in "${UMA_TREE_REPOS[@]}" 
do
  REPO_NAME="${REPO##*/}"
  UMA_GITHUB_REPOS_TO_COMPLETE="$UMA_GITHUB_REPOS_TO_COMPLETE ${REPO_NAME::-4}"
done
complete -W '$UMA_GITHUB_REPOS_TO_COMPLETE' umacd

# Add autocompletion in bash command git_clone
UMA_GITHUB_REPOS_TO_CLONE=""
for REPO in "${UMA_GITHUB_REPOS[@]}" 
do
  UMA_GITHUB_REPOS_TO_CLONE="$UMA_GITHUB_REPOS_TO_CLONE $REPO"
done
complete -W '$UMA_GITHUB_REPOS_TO_CLONE' git_clone

# Change cuda version
switch-cuda() {
  source  $HOME/uma_environment_tools/uma_installation_tools/scripts/scripts/switch-cuda.sh "$1"
}

connect-ssh-vpn() {
  source  $HOME/uma_environment_tools/uma_installation_tools/scripts/scripts/connect_ssh_vpn.sh 
}

unset REPO_NAME UMA_GITHUB_REPOS 

# now not possible, needed for umacd and git_clone
# unset UMA_GITHUB_REPOS_TO_CLONE UMA_GITHUB_REPOS_TO_COMPLETE
