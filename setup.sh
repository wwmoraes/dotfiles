#!/bin/bash

set +m # disable job control in order to allow lastpipe
shopt -s lastpipe

printf "\e[1;34mProfile-like variable exports\e[0m\n"

profileFilesList=(
  $HOME/.profile
  $HOME/.bash_profile
  $HOME/.bashrc
)

# Removes non-existent profile files
for profilePath in ${profileFilesList[@]}; do
  if [ ! -f "$profilePath" ]; then
    profileFilesList=( ${profileFilesList[@]/$profilePath} )
  fi
done

### Set environment variables
IFS=$'\n'
for entry in $(cat .env | grep -v '^#' | grep -v '^$'); do
  IFS='=' read key value <<< $entry
  value=$(echo $value)

  for profilePath in ${profileFilesList[@]}; do
    grep "export ${key}" $profilePath > /dev/null
    if [ $? -eq 0 ]; then
      printf "Updating \e[96m${key}\e[0m on \e[95m$profilePath\e[0m\n"
      sed -Ei "s|(export ${key})=.*|export ${key}=${value}|" $profilePath
    else
      printf "Adding \e[96m${key}\e[0m to \e[95m$profilePath\e[0m\n"
      echo "export ${key}=${value}" >> $profilePath
    fi
  done
done
unset IFS

# Source them to update context
for profilePath in ${profileFilesList[@]}; do
  if [ ! -f "$profilePath" ]; then
    . profilePath
  fi
done

# System paths (FIFO)
PREPATHS=(
  $HOME/.config/yarn/global/node_modules/.bin
  $HOME/.yarn/bin
  $HOME/.krew/bin
  $HOME/.cargo/bin
  $HOME/.go/bin
  $HOME/go/bin
  $HOME/.local/bin
  $HOME/bin
)

mkdir -p $HOME/.local/bin
mkdir -p $HOME/bin

for PREPATH in ${PREPATHS[@]}; do
    PATH=$PREPATH:$PATH
done

# Dedup paths
export PATH=$(echo -n $PATH | awk -v RS=: '{gsub(/\/$/,"")} !($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
for profilePath in ${profileFilesList[@]}; do
  grep "export PATH" $profilePath > /dev/null
  if [ $? -eq 0 ]; then
    printf "Updating \e[96mPATH\e[0m on \e[95m$profilePath\e[0m\n"
    sed -Ei "s|(export PATH)=.*|export PATH=$PATH|" $profilePath
  else
    printf "Adding \e[96mPATH\e[0m to \e[95m$profilePath\e[0m\n"
    echo "export PATH=$PATH" >> $profilePath
  fi
done
# used to pass to the fish script
PATHS=$PATH

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the parent has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

### setup scripts
for setupd in .setup.d/*.sh; do
  . $setupd
done

printf "\e[1;34mMiscellaneous\e[0m\n"
# Update system font cache
type -p fc-cache > /dev/null
if [ $? -eq 0 ]; then
  printf "Updating font cache...\n"
  fc-cache -f &
fi
### Set fish paths
printf "Setting fish universal variables...\n"
fish ./variables.fish $PATHS

type -p kquitapp5 > /dev/null
if [ $? -eq 0 ]; then
  printf "Updating KDE globals...\n"
  kquitapp5 kglobalaccel && sleep 2s && kglobalaccel5 &
fi

readarray VARIABLES < .env-remove

printf "\e[1;34mCleanup\e[0m\n"
# removes unused variables
for variableName in ${VARIABLES[@]}; do
  for profilePath in ${profileFilesList[@]}; do
    grep "export ${variableName}" $profilePath > /dev/null
    if [ $? -eq 0 ]; then
      printf "Removing \e[96m${variableName}\e[0m from \e[95m$profilePath\e[0m\n"
      sed -Ei "s|(export ${variableName}=.*)||" $profilePath
    fi
  done
done

printf "\e[1;32mDone!\e[0m\n"
