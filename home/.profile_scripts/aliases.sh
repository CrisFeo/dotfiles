#! /bin/bash

# Utils
alias reload-profile="source ~/.bash_profile_cfeo"
alias ped='perl -p -e'
alias hline='printf "%0.s─" $(seq 1 `tput cols`)'
alias zzz='pmset sleepnow'
alias us='underscore'


# Editors
alias mx='echo -n -e "\033]0;${PWD##*/}\007" && tmux && echo -n -e "\033]0;\007"'


# Git
alias git-current-branch="git symbolic-ref HEAD 2>/dev/null | sed 's|refs/heads/||'"
alias git-clean-branches="git co master > /dev/null  &&  git br --merged | grep -v '\*' | xargs -n 1 git branch -d  ;  git co - > /dev/null"
alias git-graph="git log --graph --abbrev-commit --all --decorate --format=format:'%C(blue)%h - %C(green)(%ar)%C(yellow)%d%C(white)%n%w(76,10,10)%s'"
alias git-watch-graph='watch -t -n 1 --color "git log --graph --abbrev-commit --all --decorate --format=format:\"%C(blue)%h - %C(green)(%ar)%C(yellow)%d%C(white)%n%w(76,10,10)%s\""'
alias git-watch-status="watch -t -n 1 --color 'git -c color.status=always status'"


# Servers
alias ip="ifconfig | grep 'inet '"
