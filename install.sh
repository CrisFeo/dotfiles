#! /bin/bash
set -e


# Install helpers
brewAdd() {
  brew install "$1" || brew upgrade "$1"
}


# Homebrew dependencies
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || :

brew update

brewAdd ag
brewAdd brew-cask
brewAdd fzf
brewAdd git
brewAdd go
brewAdd mopidy
brewAdd mpc
brewAdd ncmpcpp
brewAdd neovim
brewAdd nvm
brewAdd reattach-to-user-namespace
brewAdd tmux
brewAdd watch

brew tap caskroom/versions

brew cask install "karabiner"
brew cask install "iterm2-nightly"
brew cask install "mattr-slate"
brew cask install "seil"


# Node dependencies
# shellcheck source=/dev/null
source "$HOME/.nvm/nvm.sh"
nvm install node
npm install -g http-server
npm install -g underscore-cli


#Python dependencies
pip install neovim


# Install user Home dotfiles
FILES_SOURCE=$(find "$PWD/home" -depth 1)
FILES_DEST=${FILES_SOURCE//$PWD\/home/$HOME}
cd "$HOME" || exit
xargs -n 1 rm -r <<< "$FILES_DEST"
xargs -n 1 ln -s <<< "$FILES_SOURCE"
cd - || exit


# Karabiner
DIR_PRIVATE_XML="$HOME/Library/Application\ Support/Karabiner/private.xml"
mkdir -p "$DIR_PRIVATE_XML"
ln -sf ./karabiner/private.xml "$DIR_PRIVATE_XML"
./karabiner/import.sh


# Neovim
mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
ln -sf "$HOME/.vim" "$XDG_CONFIG_HOME/nvim"
cd "$HOME/.vim" || exit
ln -sf ../.vimrc ./init.vim
cd - || exit


# shellcheck disable=SC1091
source './home/.profile_scripts/profile.sh'
