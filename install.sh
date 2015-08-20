#! /bin/bash

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

cp -a home/. ~/

brew install brew-cask
brew install emacs
brew install node
brew install reattach-to-user-namespace
brew install tmux
brew install watch

brew-cask install atom
brew-cask install "mattr-slate"

npm install -g forever
npm install -g http-server
npm install -g underscore-cli

source ~/.bash_profile_cfeo
