#! /bin/bash


function git-current-branch {
  git symbolic-ref HEAD 2>/dev/null | sed 's|refs/heads/||'
}

function git-clean-branches {
  git co master > /dev/null  && git br --merged | grep -v '\*' | xargs -n 1 git branch -d  ;  git co - > /dev/null
}

function git-graph {
  git log \
      --graph \
      --abbrev-commit \
      --all \
      --decorate \
      --format=format:'%C(blue)%h - %C(green)(%ar)%C(yellow)%d%C(white)%n%w(76,10,10)%s'
}

function git-sync-origin {
  git fetch --all && git co master && git pull && git-clean-branches && git remote prune origin
}

function git-watch-status {
  watch -t -n 1 -c 'git -c color.status=always status'
}

function git-watch-graph {
  watch -t -n 1 -c 'bash -lc "git-graph"'
}


# Shortened Forms
alias g-a="git stage-file"
alias g-r="git unstage-file"
alias g-u="git undo"
alias g-s="git st"
alias g-c="git commit"
alias g-c-a="git commit --amend"
alias g-p="git push origin HEAD"
alias g-p-f="git push origin HEAD --force"
alias g-g="git-graph"
alias g-w-g="git-watch-graph"
alias g-w-s="git-watch-status"
