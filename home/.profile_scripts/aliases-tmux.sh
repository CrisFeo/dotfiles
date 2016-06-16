#! /bin/bash


function layout-ide {
  tmux split-window -h #{pane_current_path}
  tmux split-window -v #{pane_current_path}
  tmux split-window -v #{pane_current_path}
  tmux select-layout '98e7,178x51,0,0{120x51,0,0,85,57x51,121,0[57x16,121,0,86,57x16,121,17,87,57x17,121,34,88]}'

  tmux send-keys -t 1 'nvim' enter
  tmux send-keys -t 3 'git-watch-status' enter
  tmux send-keys -t 4 'git-watch-graph' enter

  tmux select-pane -t 2
  tmux select-pane -t 1

  tmux rename-window "$(pwd | sed -E 's;^/Users/[^/]+/;;')"
}
