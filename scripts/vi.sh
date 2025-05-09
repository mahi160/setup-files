#!/bin/bash

# Get current directory name for session
SESSION_NAME=$(basename "$PWD")

# Check if tmux session exists
tmux has-session -t "$SESSION_NAME" 2>/dev/null

if [ $? != 0 ]; then
	# Session doesn't exist, create new session and open nvim
	wezterm start -- tmux new-session -s "$SESSION_NAME" -c "$PWD" nvim &
else
	# Session exists, attach to it
	wezterm start -- tmux attach-session -t "$SESSION_NAME" &
fi

# Exit the current terminal
exit
