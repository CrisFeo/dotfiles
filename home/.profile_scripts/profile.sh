#!/usr/bin/env bash
# shellcheck disable=SC1090

## Global env vars
####################

export PATH=$PATH:$HOME/bin:$HOME/.local/bin
export EDITOR=nvim
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export FZF_DEFAULT_COMMAND='ag -l -f --hidden'

## Ruby setup
####################

if which rbenv > /dev/null; then
  export RBENV_ROOT=/usr/local/var/rbenv
  eval "$(rbenv init -)"
fi

## Tmux env vars
####################

if { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
  export IGNOREEOF=1
fi

## Bash history
####################

export HISTCONTROL=ignoreboth # ignores dups and whitespace
export HISTIGNORE=clear:ls
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTTIMEFORMAT="%F %T " # show times next to history items
shopt -s histappend

## Completions
####################

. "$HOME/.profile_scripts/completion-git.sh"
. "$HOME/.profile_scripts/completion-misc.sh"

## Aliases
####################

. "$HOME/.profile_scripts/aliases-git.sh"
. "$HOME/.profile_scripts/aliases-misc.sh"

## Prompt
####################

. "$HOME/.profile_scripts/prompt.sh"
