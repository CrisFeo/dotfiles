# Env Vars
export PLAID_ENV=dev
PATH=$PATH:$HOME/bin
export PATH

# Prompt
PS1='\[\e[2;34m\]┌──┤(\[\e[0;31m\]$(git-current-branch)\[\e[2;34m\])├─┤\[\e[0;33m\]\w\[\e[0m\] \n\[\e[2;34m\]└─►\[\e[0m\] '

# Aliases
alias git-statuswatch="while true; do clear; git st; sleep 1; done"
alias git-current-branch="git symbolic-ref HEAD 2>/dev/null | sed 's|refs/heads/||'"
