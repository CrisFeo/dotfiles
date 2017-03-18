#! /bin/bash
set -e

rm -f install.log && touch install.log

echoError() {
  printf '\e[31m%s\e[0m\n' "$@" 1>&2
}

brewInstall() {
  if ! which brew > /dev/null; then
    echo 'Installing homebrew...'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || : >> install.log 2>&1
    echo 'Complete!'
  fi
}

brewAdd() {
  if ! brew ls | grep "$1" > /dev/null; then
    echo "Installing $1..."
    if ! brew install "$@" >> install.log 2>&1; then
      echoError "Error installing $1"
    else
      echo 'Complete!'
    fi
  fi
}

brewCaskAdd() {
  if ! brew cask ls | grep "$1" > /dev/null; then
    echo "Installing $1..."
    if ! brew cask install "$@" >> install.log 2>&1; then
      echoError "Error installing $1"
    else
      echo 'Complete!'
    fi
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

  echo 'Tapping repositories...'
  brew tap caskroom/versions >> install.log 2>&1
  brew tap homebrew/dupes >> install.log 2>&1
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

  # Kakoune is a bit weird: the main formula is out-of-date and broken
  brewAdd homebrew/dupes/ncurses
  brewAdd https://raw.githubusercontent.com/mawww/kakoune/master/contrib/kakoune.rb --HEAD

  brewCaskAdd 'karabiner-elements'
  brewCaskAdd 'iterm2-nightly'
  brewCaskAdd 'hammerspoon'


  # Node dependencies
  echo 'Installing node...'
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
  echo "Home files to be linked:"
  printf '+ %s\n' "$FILES_SOURCE"
  cd "$HOME" || exit
  xargs -n 1 rm -rf <<< "$FILES_DEST"
  xargs -n 1 ln -s <<< "$FILES_SOURCE"
  cd - || exit
} >> install.log 2>&1
echo 'Complete!'

echo 'Sourcing profile...'
{
  # shellcheck disable=SC1091
  source './home/.profile_scripts/profile.sh'
} >> install.log 2>&1
echo 'Complete!'

echo 'Dotfile installation completed'
