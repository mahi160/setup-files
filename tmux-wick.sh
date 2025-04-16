#!/bin/bash
if [ "$KITTY" != "true" ]; then
  export KITTY=true
  exec kitty -e "$0" "$@" &
  exit 0
fi
# Set your work directory here
WORK_DIR="$HOME/Documents/Coding/Jobs/QuestionPro/wick-ui/"

# Check if "wick" session exists
if tmux has-session -t wick 2>/dev/null; then
  # If it exists, attach to it
  tmux attach-session -t wick
else
  # Change to work directory
  cd "$WORK_DIR" || exit 1

  # Create new session named "wick" with first window
  tmux new-session -d -s wick -n editor

  # Window 1: nvim with current directory
  tmux send-keys -t wick:editor 'nvim .' C-m
  sleep 0.1

  # Window 2: Left - tests, Right - two panes (top: pnpm dev, bottom: focused)
  tmux new-window -t wick -n dev
  tmux send-keys -t wick:dev 'cd ./wick-ui-lib && pnpm test:ui' C-m
  sleep 0.1

  # Split window into two columns (left 50%, right 50%)
  tmux split-window -h -t wick:dev
  tmux send-keys -t wick:dev.2 'pnpm i && cd ./wick-ui-lib && pnpm dev' C-m
  sleep 0.1

  # Split the right pane into two (top 50%, bottom 50%)
  tmux split-window -v -t wick:dev.2

  # Select the bottom-right pane as focused
  tmux select-pane -t wick:dev.3

  # Window 3: lazygit
  # tmux new-window -t wick -n git
  # tmux send-keys -t wick:git 'lazygit' C-m
  # sleep 0.1

  # Select the first window as starting point
  tmux select-window -t wick:editor

  # Attach to the session
  tmux attach-session -t wick
fi
