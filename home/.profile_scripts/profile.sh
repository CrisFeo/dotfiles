#! /bin/bash

## Global env vars
export PATH=$PATH:$HOME/bin:$HOME/.cabal/bin
export EDITOR=emacs


## Tmux-specific env vars
if { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
   export IGNOREEOF=1
fi


## Completions
source "$HOME/.profile_scripts/completion-git.sh"


## Aliases
source "$HOME/.profile_scripts/aliases-git.sh"
source "$HOME/.profile_scripts/aliases-misc.sh"


## Prompt
source "$HOME/.profile_scripts/prompt.sh"
