#!/usr/bin/env bash

## Editors
####################

vim-open() {
FZF_COLORS='fg:230,bg:235,hl:106,fg+:230,bg+:235,hl+:106,info:106,prompt:106,spinner:230,pointer:106,marker:166'
(cd "${1:-.}"                                                    && \
  CHOSEN_FILES=$(ag --nocolor --hidden --ignore "./.git" -g "" |    \
                 fzf --color=$FZF_COLORS --multi --cycle)        && \
  xargs nvim <<< "$CHOSEN_FILES")
}
alias v-o='vim-open'

notepad() {
  nvim -c ':set background=light' \
       -c ':PencilHard' \
       -c ':set nonumber' \
       -c ':set norelativenumber' \
       -c ':set simple_config=1'
}

## Formatting
####################

crop-text() {
  lines="$(tput lines)"
  cols="$( tput cols)"
  printf '%s' "$1" | fold -s -w "$cols" | head -n "$lines"
}

to-msec() {
  read -r a b c <<< "$(echo "$1" | sed -E 's/:0+/:/' | tr ':' ' ' )"
  if [ -z "$b" ] && [ -z "$c" ]; then
     printf '%s' "$((a*1000))"
  elif [ -z "$c" ]; then
    printf '%s' "$(((a*60*1000)+(b*1000)))"
  else
    printf '%s' "$(((a*60*60*1000)+(b*60*1000)+(c*1000)))"
  fi
}

from-msec() {
  hour=$(($1/(60*60*1000)))
  min=$((($1%(60*60*1000))/(60*1000)))
  sec=$((($1%(60*1000))/1000))
  printf '%i:%02i:%02i' $hour $min $sec | sed -E 's/^0+:0?//'
}

truncate-string() {
  if [ "${#2}" -gt "$1" ]; then
    printf '%s…' "$(cut -c -"$1" <<< "$2")"
  else
    printf '%s' "$2"
  fi
}

## Watching
####################

watch-command() {
  (
  interval="$1"
  cmd="$2"
  lastColumns=""
  lastOutput=""
  trap 'clear; exit' 2 3
  while true; do
    columns=$(tput cols)
    output=$(eval "$cmd" 2>&1 || :)
    if [ ! "$columns" -eq "$lastColumns" ] || \
       [ "$output" != "$lastOutput" ]
    then
      results="$(crop-text "$output")"
      clear
      printf "%s" "$results"
    fi
    lastOutput="$output"
    lastColumns="$columns"
    sleep "$interval"
  done
  )
}

## Node REPL
####################

node-repl() {
  NODE_PATH=${1:-}
  IMPORTS=${2:-}
  (env \
    NODE_PATH="$NODE_PATH" \
    NODE_NO_READLINE=1 \
    RLWRAP_EDITOR='nvim --cmd "let simple_config = 1"' \
    rlwrap -m'
  ' -M '.js' -P "$IMPORTS" node)
}

node-repl-functional() {
  node-repl \
    "$(npm root -g)" \
    'const R = require("ramda"); const S = require("sanctuary");'
}

## Path
####################

# Retrieve the physical path (with all symlinks resolved) for the provided
# virtual path in a cross-platform compatible manner. Utilizes `cd` but amends
# the history such that `cd -` will still work.
physical-path() {
  cd "$1" || return
  physicalPath="$(pwd -P)"
  cd - 2>/dev/null || return
  echo "$physicalPath"
}

# Change to the full path of the provided directory or the current directory if
# one is not provided.
# shellcheck disable=SC2120
cd-full() {
  cd "$(physical-path "${1:-'.'}")" || return
}

## Miscellaneous
####################

# Takes an input path and either paginates it using `less` if its a file or
# lists contents using `ls` if its a directory.
ls-less() {
  if [ -d "$1" ]; then
    ls "$1"
  else
    less "$1"
  fi
}
alias l='ls-less'

# Print a horizontal bar spanning the width of the terminal.
hline() {
  # shellcheck disable=SC2046
  printf "%0.s─" $(seq $(tput cols))
}

alias generate-tags-go='gotags $(find . -name "*.go" -not -path "./vendor/*") > tags'
alias mopidy-start='nohup mopidy > /dev/null 2>&1 &'
alias reload-profile="source ~/.bash_profile"
alias v='nvim'
