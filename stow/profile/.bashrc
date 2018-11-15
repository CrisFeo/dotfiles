stty -ixon

export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:/Applications/Unity/Unity.app/Contents/Tools"

export EDITOR=kak
export MANPAGER=kak-man-pager
export PAGER=kak-pager

export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export PROMPT_DIRTRIM=3

alias view="vim -c 'set ts=2 nomod nolist nonu noma'"

for f in $HOME/.profile.d/*; do . "$f"; done

export NVM_DIR="/Users/CrisFeo/.nvm"
