#! /bin/bash
set -e

rm -f install.log && touch install.log

brewInstall() {
  ret=0; (which brew > /dev/null) || ret=$?
  if [[ $ret != 0 ]]; then
    echo 'Installing homebrew...'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || : >> install.log 2>&1
    echo 'Complete!'
  fi
}

brewAdd() {
  ret=0; (brew ls | grep "$1" > /dev/null) || ret=$?
  if [[ $ret != 0 ]]; then
    echo "Installing $1..."
    brew install "$1" >> install.log 2>&1
    echo 'Complete!'
  fi
}

if [ "$1" != '--skip-install' ]; then
  # Homebrew
  brewInstall

  echo 'Update homebrew package list...'
  brew update >> install.log 2>&1
  echo 'Complete!'

  echo 'Upgrading installed homebrew packages...'
  brew upgrade >> install.log 2>&1
  echo 'Complete!'

  brewAdd ag
  brewAdd bash
  brewAdd fzf
  brewAdd git
  brewAdd go
  brewAdd gotags
  brewAdd jq
  brewAdd koekeishiya/formulae/khd
  brewAdd mopidy
  brewAdd mpc
  brewAdd ncmpc
  brewAdd neovim
  brewAdd nvm
  brewAdd reattach-to-user-namespace
  brewAdd tmux
  brewAdd watch

  echo 'Installing brew casks...'
  {
    brew tap caskroom/versions
    brew cask install 'karabiner-elements'
    brew cask install 'iterm2-nightly'
    brew cask install 'hammerspoon'
  } >> install.log 2>&1
  echo 'Complete!'


  # Node dependencies
  echo 'Installing node dependencies...'
  {
    # shellcheck source=/dev/null
    source "$HOME/.nvm/nvm.sh"
    nvm install node
  } >> install.log 2>&1
  echo 'Complete!'


  # Neovim dependencies
  echo 'Installing neovim dependencies...'
  {
    unset PYTHONPATH # Just in case to make sure install doesn't fail
    brewAdd python3
    pip install neovim
    pip3 install neovim
    sudo gem install neovim
  } >> install.log 2>&1
  echo 'Complete!'
fi


# Install user Home dotfiles
echo 'Symlinking dotfiles into user home...'
{
  FILES_SOURCE=$(find "$PWD/home" -depth 1)
  FILES_DEST=${FILES_SOURCE//$PWD\/home/$HOME}
  echo "Files: $FILES_SOURCE"
  cd "$HOME" || exit
  xargs -n 1 rm -rf <<< "$FILES_DEST"
  xargs -n 1 ln -s <<< "$FILES_SOURCE"
  cd - || exit
} >> install.log 2>&1
echo 'Complete!'

# Neovim
echo 'Symlinking neovim configs to vim configs...'
{
  mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
  ln -sf "$HOME/.vim" "$XDG_CONFIG_HOME/nvim"
  cd "$HOME/.vim" || exit
  ln -sf ../.vimrc ./init.vim
  cd - || exit
} >> install.log 2>&1
echo 'Complete!'


echo 'Sourcing profile...'
{
  # shellcheck disable=SC1091
  source './home/.profile_scripts/profile.sh'
} >> install.log 2>&1
echo 'Complete!'
