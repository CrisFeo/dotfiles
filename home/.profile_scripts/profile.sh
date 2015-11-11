#! /bin/bash

## Global Env Vars
export PATH=$PATH:$HOME/bin
export EDITOR=emacs


## Completions
source "$HOME/.profile_scripts/completion-git.sh"


## Aliases
source "$HOME/.profile_scripts/aliases-git.sh"
source "$HOME/.profile_scripts/aliases-misc.sh"


## Prompt
source "$HOME/.profile_scripts/prompt.sh"
