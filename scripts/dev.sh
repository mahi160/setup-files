#!/bin/bash

# Check if directory argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Change into the provided directory
cd "$1" || exit 1

# If not already in Alacritty, open a new Alacritty window and rerun the script inside it
if [ "$ALACRITTY" != "true" ]; then
  export ALACRITTY=true
  exec alacritty --working-directory "$PWD" -e "$0" "$PWD" &
  exit 0
fi

# Start an unnamed tmux session and open nvim
tmux new-session -d
tmux send-keys 'nvim .' C-m

# Attach to the new tmux session
tmux attach-session
