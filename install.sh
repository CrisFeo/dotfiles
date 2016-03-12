#! /bin/bash


# Homebrew Dependencies
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install brew-cask
brew install emacs
brew install node
brew install reattach-to-user-namespace
brew install tmux
brew install watch
brew install mopidy
brew install mpc
brew install ncmpcpp

brew-cask install atom
brew-cask install "mattr-slate"


# NPM Dependencies
npm install -g forever
npm install -g http-server
npm install -g underscore-cli


# Install Dotfiles
# Warning: this will delete existing files!
FILES_SOURCE=`find "$PWD/home" -depth 1`
FILES_DEST=${FILES_SOURCE//$PWD\/home/$HOME}
cd "$HOME"
xargs -n 1 rm -r <<<$FILES_DEST
xargs -n 1 ln -s <<<$FILES_SOURCE
cd -

source "$HOME/.profile_scripts/profile.sh"
