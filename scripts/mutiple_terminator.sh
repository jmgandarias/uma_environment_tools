#!/bin/bash
#
#  Author: Pietro Balatti
#  email: pietro.balatti@iit.it
#
# This script opens a new terminator windows divided in multiple subwindows and executes the command in input
#
# Example to open 4 windows and execute the "ls -la" command:
# source /PATH/TO/SCRIPT/mutiple_terminator.sh -w 4 "ls -la"
#

# Initial warning on xdotool
pkg_output=$(apt-cache policy xdotool)
if echo $pkg_output|grep -q 'Installed: (none)'; then
  echo "The required pkg \"xdotool\" is not installed. Please install it by running \"sudo apt install -y xdotool\""
  return 0;
fi

# Handling options
windows=1;
command="";
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -w|--windows) windows="$2"; shift ;;
        -h|--help) echo -e "usage: multiple_terminator [-w | --windows] [-h | --help] [command]\n\ncurrently supported options\n\twindows     \t\tnumber of windows to open\n\thelp     \t\tshows this help\n\tcommand     \t\tto be executed in each terminal window"; return 0;;
        *) echo "Command to be executed: $1"; command=$1;;
    esac
    shift
done

if [[ "$windows" -gt 4 ]]; then
  echo "Maximum number of supported windows is 4!"
fi

# Open a new terminator windows and maximize it
terminator
xdotool key Super_L+Up

# Open new tab (needed later to focus on all windows of this window only)
xdotool key Control_L+Shift_L+t;

# Split main windows in 2 horizontal windows
if [[ "$windows" -gt 1 ]]; then
  xdotool key Control_L+Shift_L+o;
fi

# Focus on upper window and split it in 2 vertical windows
if [[ "$windows" -gt 2 ]]; then
  xdotool key --delay 200 Alt_L+Up
  xdotool key Control_L+Shift_L+e;
fi

# Focus on lower window and split it in 2 vertical windows
if [[ "$windows" -gt 3 ]]; then
  xdotool key --delay 200 Alt_L+Down
  xdotool key Control_L+Shift_L+e;
fi

if [ ! -z "$command" ]; then
  # Focus on all windows
  xdotool key Super_L+t
  xdotool key Alt_L+g

  # Go back to original tab and delete it
  xdotool key Control_L+Page_Up
  xdotool key Control_L+Shift_L+w
  
  # Execute the input command
  xdotool type "$command"
  xdotool key Return

  # Remove all windows focus and go to top left window
  xdotool key --delay 200 Alt_L+o
  xdotool key --delay 200 Alt_L+Up
  xdotool key --delay 200 Alt_L+Left
fi

