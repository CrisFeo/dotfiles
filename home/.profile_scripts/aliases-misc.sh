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


# Underscore-cli
function us-sed {
  underscore --infmt=text --outfmt=text map "value.replace($1, '$2')"
}

function us-grep {
  underscore --infmt=text --outfmt=text filter "value.match(/$1/)"
}


# Servers
function start-server {
  http-server -p "$1"
}

function start-server-ssl {
  http-server -p "$1" -S -C "$HOME/.ssl/server.crt" -K "$HOME/.ssl/server.key"
}


# Utils
alias reload-profile="source ~/.bash_profile_cfeo"
alias ped='perl -p -e'
alias hline='printf "%0.s─" $(seq 1 `tput cols`)'
alias zzz='pmset sleepnow'
alias us='underscore'
alias fig='figlet -w `tput cols`'
alias ip="ifconfig | grep 'inet '"
