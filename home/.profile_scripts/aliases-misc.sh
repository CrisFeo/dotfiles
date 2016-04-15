#! /bin/bash


# Editors
function tmux-workspace {
  tmux new \; \
       split-window 'bash -lc "git-watch-status" && bash -il' \; \
       split-window 'bash -lc "git-watch-graph" && bash -il'  \; \
       select-layout 'fc0f,178x39,0,0{99x39,0,0,215,78x39,100,0[78x24,100,0,216,78x14,100,25,217]}' \; \
       select-pane -L
}

function mx-workspace {
  echo -n -e "\033]0;${PWD##*/}\007" && \
      tmux-workspace && \
      echo -n -e "\033]0;\007"
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
  interval="$1"
  cmd="$2"
  last=""
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


# Utils
alias mopidy-start='nohup mopidy > /dev/null 2>&1 &'
alias reload-profile="source ~/.bash_profile"
alias ped='perl -p -e'
alias hline='printf "%0.s─" $(seq 1 `tput cols`)'
alias zzz='pmset sleepnow'
alias us='underscore'
alias fig='figlet -w `tput cols`'
alias ip="ifconfig | grep 'inet '"
alias emacs='TERM=xterm-256color emacs'
alias node-repl="env NODE_NO_READLINE=1 rlwrap node --harmony"
