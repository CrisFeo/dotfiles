#!/usr/bin/env bash
# shellcheck disable=SC1090

## Global env vars
####################

export PATH=$PATH:$HOME/bin:$HOME/.local/bin
export EDITOR=nvim
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

## Sane fzf defaults
####################
FZF_NO_COLORS=''
FZF_NO_COLORS+='fg:-1,fg+:-1,'
FZF_NO_COLORS+='bg:-1,bg+:-1,'
FZF_NO_COLORS+='hl:-1,hl+:-1,'
FZF_NO_COLORS+='info:-1,'
FZF_NO_COLORS+='prompt:-1,'
FZF_NO_COLORS+='pointer:-1,'
FZF_NO_COLORS+='marker:-1,'
FZF_NO_COLORS+='spinner:-1,'
FZF_NO_COLORS+='header:-1'
export FZF_NO_COLORS
export FZF_DEFAULT_COLORS="$FZF_NO_COLORS,pointer:2,marker:2,prompt:2,hl:3,hl+:3"

export FZF_DEFAULT_COMMAND='ag -l -f --hidden --ignore=".git"'
export FZF_DEFAULT_OPTS="--ansi --no-bold --color=$FZF_DEFAULT_COLORS"

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
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

## z directory changer
####################
. /usr/local/etc/profile.d/z.sh

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
