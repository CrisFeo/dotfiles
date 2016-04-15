#! /bin/bash


# Homebrew Dependencies
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install ag
brew install brew-cask
brew install emacs
brew install fzf
brew install macvim
brew install node
brew install reattach-to-user-namespace
brew install tmux
brew install watch
brew install mopidy
brew install mpc
brew install ncmpcpp

brew cask install "mattr-slate"
brew cask install "iterm2"


# NPM Dependencies
npm install -g http-server
npm install -g underscore-cli


# Install Dotfiles
# Warning: this will delete existing files!
FILES_SOURCE=$(find "$PWD/home" -depth 1)
FILES_DEST=${FILES_SOURCE//$PWD\/home/$HOME}
cd "$HOME" || exit
xargs -n 1 rm -r <<<"$FILES_DEST"
xargs -n 1 ln -s <<<"$FILES_SOURCE"
cd - || exit

# shellcheck disable=SC1091
source './home/.profile_scripts/profile.sh'
