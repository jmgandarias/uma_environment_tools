#!/bin/bash

source ~/.hrii_params.env

source $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/ros/startup_ros_env.sh
source $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/hrii_env/hrii_aliases.sh
source $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/git/git_user_check.sh
source $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/gitlab/create_gitlab_dir.sh

# Add PATH export to include pymodbus and pyserial scripts
export PATH="$PATH:/home/$USER/.local/bin"

# Add LD_LIBRARY_PATH export to include matlogger2 for python
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/git/hrii_gitlab/general/matlogger2/build"

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

# Add autocompletion in bash command hriicd
HRII_GITLAB_REPOS_TO_COMPLETE=""
for REPO in "${HRII_TREE_GITLAB_REPOS[@]}" 
do
  REPO_NAME="${REPO##*/}"
  HRII_GITLAB_REPOS_TO_COMPLETE="$HRII_GITLAB_REPOS_TO_COMPLETE ${REPO_NAME::-4}"
done
complete -W '$HRII_GITLAB_REPOS_TO_COMPLETE' hriicd

# Add autocompletion in bash command git_clone
HRII_GITLAB_REPOS_TO_CLONE=""
for REPO in "${HRII_GITLAB_REPOS[@]}" 
do
  HRII_GITLAB_REPOS_TO_CLONE="$HRII_GITLAB_REPOS_TO_CLONE $REPO"
done
complete -W '$HRII_GITLAB_REPOS_TO_CLONE' git_clone

# Change cuda version
switch-cuda() {
  source  $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/switch-cuda.sh "$1"
}

connect-ssh-vpn() {
  source  $HOME/git/hrii_gitlab/general/hrii_installation_tools/scripts/connect_ssh_vpn.sh 
}

unset REPO_NAME HRII_GITLAB_REPOS 

# now not possible, needed for hriicd and git_clone
# unset HRII_GITLAB_REPOS_TO_CLONE HRII_GITLAB_REPOS_TO_COMPLETE
