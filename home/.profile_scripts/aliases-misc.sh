#! /bin/bash


FZF_COLORS='fg:230,bg:235,hl:106,fg+:230,bg+:235,hl+:106,info:106,prompt:106,spinner:230,pointer:106,marker:166'

# Editors
function vim-open {
  (cd "${1:-.}"                                                  && \
  CHOSEN_FILES=$(ag --nocolor --hidden --ignore "./.git" -g "" |    \
                 fzf --color=$FZF_COLORS --multi --cycle)        && \
  xargs nvim <<< "$CHOSEN_FILES")
}

# Formatting
function crop-text {
  lines="$(tput lines)"
  cols="$( tput cols)"
  echo -n "$1" | fold -s -w "$cols" | head -n "$lines"
}


# Underscore-cli
function us-sed {
  underscore --infmt=text --outfmt=text map "value.replace($1, '$2')"
}

function us-grep {
  underscore --infmt=text --outfmt=text filter "value.match(/$1/)"
}


# Servers
function start-server {
  http-server -p "$@"
}

function start-server-ssl {
  http-server -p "$@" -S -C "$HOME/.ssl/server.crt" -K "$HOME/.ssl/server.key"
}


# Watching
watch-command() {
  (
  interval="$1"
  cmd="$2"
  last=""
  trap 'clear; exit' 2 3
  while true; do
    output=$(eval "$cmd" 2>&1 || :)
    if [ "$output" != "$last" ]; then
      results="$(crop-text "$output")"
      clear
      echo -n "$results"
    fi
    last="$output"
    sleep "$interval"
  done
  )
}


# Calendars
agenda() {
  calendar="$1"
  if [ "$calendar" == '' ]; then
    gcalcli list
  else
    today="$(date '+%m/%d/%Y')"
    tomorrow="$(date -v+1d '+%m/%d/%Y')"
    gcalcli --calendar "$calendar" agenda "$today" "$tomorrow"
  fi
}

agenda-cris() {
  agenda cris@plaid.com
}

agenda-plaid() {
  agenda Team
}

node-repl() {
  IMPORTS='const R = require("ramda"); const S = require("sanctuary");'
  (cd ~/personal/functional-playground/javascript || exit 1;\
   env NODE_NO_READLINE=1 \
   RLWRAP_EDITOR='nvim --cmd "let simple_config = 1"' \
   rlwrap -m'
' -M '.js' -P "$IMPORTS" node)
}

ls-less() {
  if [ -d "${@: -1}" ]; then
    ls "$@"
  else
    less "$@"
  fi
}


# Utils
alias cd-full='cd "$(pwd -P)"'
alias format-json='~/.profile_scripts/utilities/format-json'
alias generate-tags-go='gotags $(find . -name "*.go" -not -path "./vendor/*") > tags'
alias mopidy-start='nohup mopidy > /dev/null 2>&1 &'
alias reload-profile="source ~/.bash_profile"
alias ped='perl -p -e'
alias hline='printf "%0.s─" $(seq 1 `tput cols`)'
alias zzz='pmset sleepnow'
alias us='underscore'
alias fig='figlet -w `tput cols`'
alias ip="ifconfig | grep 'inet ' | grep -v 127.0.0.1"
alias v='nvim'
alias v-o='vim-open'
alias l='ls-less'
