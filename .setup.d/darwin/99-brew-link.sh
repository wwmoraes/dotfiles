#!/bin/bash
###
### Homebrew doesn't link keg-only packages to /usr/local/{bin,sbin},
###   even with `brew link --force <package>`
###   instead, they recommend adding /usr/local/opt/<package>/{bin,sbin}
###   to your path (LOL). Democracy uh?
###

printf "\e[1;33mHomebrew (correct) linking\e[0m\n"

CHECKMARK=$(printf "\xE2\x9C\x94")
CROSSMARK=$(printf "\xE2\x9C\x96")
RIGHTWARDS_ARROW=$(printf "\xE2\x9E\xBE")

rm -rf $HOME/.local/opt/{bin,sbin}
mkdir -p $HOME/.local/opt/{bin,sbin}

for package in $(ls /usr/local/opt/); do
  # echo $package
  printf "Cheking \e[96m${package}\e[0m... "

  BINS=()

  if [ -d /usr/local/opt/$package/bin ]; then
    for bin in $(ls /usr/local/opt/$package/bin); do
      type -p $bin &> /dev/null
      if [ $? -ne 0 ]; then
        BINS+=("$bin")
        ln -sf /usr/local/opt/$package/bin/$bin ~/.local/opt/bin
      fi
    done
  fi

  if [ -d /usr/local/opt/$package/sbin ]; then
    for sbin in $(ls /usr/local/opt/$package/sbin); do
      type -p $sbin &> /dev/null
      if [ $? -ne 0 ]; then
        BINS+=("$sbin")
        ln -sf /usr/local/opt/$package/sbin/$sbin ~/.local/opt/sbin
      fi
    done
  fi

  if [[ ${#BINS[@]} -gt 0 ]]; then
    printf "\e[91m${CROSSMARK}\e[0m ${RIGHTWARDS_ARROW} ${BINS[*]}\n"
  else
    printf "\e[92m${CHECKMARK}\e[0m\n"
  fi
done
