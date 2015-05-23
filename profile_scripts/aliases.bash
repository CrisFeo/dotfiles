alias sublime="subl -n"
alias git-watch-status="while true; do clear; git st; sleep 1; done"
alias git-current-branch="git symbolic-ref HEAD 2>/dev/null | sed 's|refs/heads/||'"
alias git-clean-branches="git co master > /dev/null  &&  git br --merged | grep -v '\*' | xargs -n 1 git branch -d  ;  git co - > /dev/null"
