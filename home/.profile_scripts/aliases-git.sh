#! /bin/bash


function git-current-branch {
  showDetached=$1
  branch="$(git symbolic-ref HEAD 2>/dev/null)"
  if [ $? -eq 0 ]; then
    sed 's|refs/heads/||' <<< "$branch"
  elif [ -n "$showDetached" ]; then
    printf '\033[0;31mDETACHED\n'
  fi
}

function git-branch-status {
  branch="$(git status -sb | sed -En 's|^## ([^.]+).*$|\1|p')"
  pos="$(git status -sb | sed -En 's|^## .*\[(.+) .*\]$|\1|p')"
  num="$( git status -sb | sed -En 's|^## .*\[[^ ]+ (.+)\]$|\1|p')"
  if [ -z "$pos" ]; then
    printf ' \033[0;33m%s\e[0m\n' "$branch"
  else
    printf ' \033[0;33m%s\e[0m [%s \033[0;34m%s\e[0m]\n' "$branch" "$pos" "$num"
  fi
}

function git-clean-branches {
  git co master > /dev/null  && git br --merged          | \
                                grep -v '\*'             | \
                                xargs -n 1 git branch -d ; \
                                git co - > /dev/null
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
  git fetch --all && \
  git co master && \
  git pull && \
  git-clean-branches && \
  git remote prune origin
}

function git-watch-status {
  watch-command 1 'git-branch-status && git -c color.status=always status -s'
}

function git-watch-graph {
  watch-command 1 'git-graph'
}

function git-quick-amend {
  if [ "$(git-current-branch)" == "master" ]; then
    echo "You can't amend on master"
  else
    echo "Amending last commit..."
    git stage-file && \
    git commit --amend --no-edit && \
    git push origin HEAD --force
  fi
}

function git-new-feature {
  git-sync-origin
  git br-co "cf-$1"
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
