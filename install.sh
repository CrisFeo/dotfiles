#! /bin/bash
set -e


# Install helpers
brewAdd() {
  brew install "$1" || brew upgrade "$1"
}

brewAddCask() {
  brew cask install "$1" || brew cask upgrade "$1"
}


# Homebrew dependencies
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || :

brewAdd ag
brewAdd brew-cask
brewAdd fzf
brewAdd git
brewAdd go
brewAdd mopidy
brewAdd mpc
brewAdd ncmpcpp
brewAdd node
brewAdd nvim
brewAdd reattach-to-user-namespace
brewAdd tmux
brewAdd watch

brew tap caskroom/versions

brewAddCask "karabiner"
brewAddCask "iterm2-nightly"
brewAddCask "mattr-slate"
brewAddCask "seil"


# NPM dependencies
npm install -g http-server
npm install -g underscore-cli


#Python dependencies
pip install neovim


# Install $HOME Dotfiles
# Warning: this will delete existing files!
FILES_SOURCE=$(find "$PWD/home" -depth 1)
FILES_DEST=${FILES_SOURCE//$PWD\/home/$HOME}
cd "$HOME" || exit
xargs -n 1 rm -r <<<"$FILES_DEST"
xargs -n 1 ln -s <<<"$FILES_SOURCE"
cd - || exit


# Karabiner
DIR_PRIVATE_XML="$HOME/Library/Application\ Support/Karabiner/private.xml"
mkdir -p "$DIR_PRIVATE_XML"
ln -sf ./karabiner/private.xml "$DIR_PRIVATE_XML"
./karabiner/import.sh


# Neovim
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
ln -sf ~/.vim $XDG_CONFIG_HOME/nvim
cd $HOME/.vim || exit
ln -sf ../.vimrc ./init.vim
cd - || exit


# shellcheck disable=SC1091
source './home/.profile_scripts/profile.sh'
