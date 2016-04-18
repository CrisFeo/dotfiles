#! /bin/bash

## Global env vars
export PATH=$PATH:$HOME/bin:$HOME/.cabal/bin
export EDITOR=nvim
export FZF_DEFAULT_COMMAND='ag -l -f --hidden'

## Tmux-specific env vars
if { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
  export TERM=xterm-256color
  export IGNOREEOF=1
fi


## Completions
source "$HOME/.profile_scripts/completion-git.sh"
source "$HOME/.profile_scripts/completion-misc.sh"


## Aliases
source "$HOME/.profile_scripts/aliases-git.sh"
source "$HOME/.profile_scripts/aliases-misc.sh"
source "$HOME/.profile_scripts/aliases-tmux.sh"


## Prompt
source "$HOME/.profile_scripts/prompt.sh"
