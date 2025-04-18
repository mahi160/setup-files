#!/bin/bash

# Get the directory passed as an argument or use the current directory
TARGET_DIR="${1:-$(pwd)}"

# Ensure the directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Directory $TARGET_DIR does not exist. Exiting."
  exit 1
fi

# Start WezTerm with a shell, holding the terminal open
if [ "$KITTY" != "true" ]; then
  export KITTY=true
  exec kitty -e "$0" "$@" &
  exit 0
fi
# Change to the specified directory
cd "$TARGET_DIR" &&

  # Start tmux and run nvim in the first pane
  tmux new-session -d 'nvim .' &&

  # Attach to the tmux session
  tmux attach
