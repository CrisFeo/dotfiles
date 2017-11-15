stty -ixon

export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/.bin"

export EDITOR=vim
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export PROMPT_DIRTRIM=3

for f in $HOME/.profile.d/*; do . "$f"; done
