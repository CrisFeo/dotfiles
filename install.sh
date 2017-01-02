#! /bin/bash
set -e

if [ "$1" != '--skip-install' ]; then
  # Install helpers
  brewAdd() {
    brew install "$1" || brew upgrade "$1"
  }


  # Homebrew dependencies
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || :

  brew update

  brewAdd ag
  brewAdd fzf
  brewAdd git
  brewAdd go
  brewAdd gotags
  brewAdd jq
  brewAdd mopidy
  brewAdd mpc
  brewAdd ncmpc
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


  # Neovim dependencies
  unset PYTHONPATH # Just in case to make sure install doesn't fail
  brewAdd python3
  pip install neovim
  pip3 install neovim
  sudo gem install neovim
fi


# Install user Home dotfiles
FILES_SOURCE=$(find "$PWD/home" -depth 1)
FILES_DEST=${FILES_SOURCE//$PWD\/home/$HOME}
cd "$HOME" || exit
xargs -n 1 rm -rf <<< "$FILES_DEST"
xargs -n 1 ln -s <<< "$FILES_SOURCE"
cd - || exit


# Karabiner
DIR_PRIVATE_XML="$HOME/Library/Application Support/Karabiner"
mkdir -p "$DIR_PRIVATE_XML"
cp -f ./karabiner/private.xml "$DIR_PRIVATE_XML"
./karabiner/import.sh


# Neovim
mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
ln -sf "$HOME/.vim" "$XDG_CONFIG_HOME/nvim"
cd "$HOME/.vim" || exit
ln -sf ../.vimrc ./init.vim
cd - || exit


# shellcheck disable=SC1091
source './home/.profile_scripts/profile.sh'
