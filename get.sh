#!/bin/sh

# Clone the main dotfiles
if [ ! -d ~/.dotfiles ]; then 
  git clone https://github.com/wwmoraes/dotfiles.git ~/.dotfiles
  
  pushd ~/.dotfiles > /dev/null
  git remote set-url origin git@github.com:wwmoraes/dotfiles.git
  make install
  popd > /dev/null
else
  echo "dotfiles already cloned."
fi

# Clone the secrets
if [ ! -d ~/.dotsecrets ]; then
  xdg-open https://github.com/settings/tokens
  echo -n "Paste a personal access token: "
  read personalToken
  echo $personalToken

  git clone https://${personalToken}@github.com/wwmoraes/secrets.git ~/.dotsecrets
  pushd ~/.dotsecrets > /dev/null
  git remote set-url origin git@github.com:wwmoraes/secrets.git
  make install
  popd > /dev/null
else
  echo "dotsecrets already cloned."
fi
