#! /bin/bash
set -e

if [ "$1" != '--skip-install' ]; then
  # Homebrew dependencies

  brewAdd() {
    brew ls | grep "$1" > /dev/null
    if [[ $? == 0 ]]; then
      brew install "$1"
    else
      brew upgrade "$1"
    fi
  }

  which brew > /dev/null
  if [[ $? != 0 ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || :
  fi

  brew update

  brewAdd ag
  brewAdd fzf
  brewAdd git
  brewAdd go
  brewAdd gotags
  brewAdd jq
  brewAdd khd
  brewAdd mopidy
  brewAdd mpc
  brewAdd ncmpc
  brewAdd neovim
  brewAdd nvm
  brewAdd reattach-to-user-namespace
  brewAdd tmux
  brewAdd watch

  brew tap caskroom/versions

  # Don't install karabiner-elements with brew cask until this PR is
  # merged/resolved: https://github.com/tekezo/Karabiner-Elements/pull/247
  # Until then, install the fork releases from here manually:
  # https://github.com/wwwjfy/Karabiner-Elements/releases
  #brew cask install "karabiner-elements"
  brew cask install "iterm2-nightly"
  brew cask install "mattr-slate"


  # Node dependencies
  # shellcheck source=/dev/null
  source "$HOME/.nvm/nvm.sh"
  nvm install node


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

# Neovim
mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
ln -sf "$HOME/.vim" "$XDG_CONFIG_HOME/nvim"
cd "$HOME/.vim" || exit
ln -sf ../.vimrc ./init.vim
cd - || exit


# shellcheck disable=SC1091
source './home/.profile_scripts/profile.sh'
