#! /bin/bash

## Global env vars
export PATH=$PATH:$HOME/bin
export EDITOR=vim
export FZF_DEFAULT_COMMAND='ag -l -f --hidden'

## Tmux-specific env vars
if { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
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
