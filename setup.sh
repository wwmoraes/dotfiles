#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# import common functions
# shellcheck source=functions.sh
. functions.sh

printf "\e[1;34mProfile-like variable exports\e[0m\n"

sourceFiles "${HOME}/.profile"

PYTHON_PATH=
if command -V python3 > /dev/null 2>&1; then
  PYTHON_PATH=$(python3 -m site --user-base)/bin
fi

# System paths (FIFO)
PREPATHS=$(join ":" \
  "${PYTHON_PATH}" \
  "${HOME}/.config/yarn/global/node_modules/.bin" \
  "${HOME}/.local/google-cloud-sdk/bin" \
  "${HOME}/.yarn/bin" \
  "${HOME}/.krew/bin" \
  "${HOME}/.cargo/bin" \
  "${HOME}/go/bin" \
  "${HOME}/.local/opt/bin" \
  "${HOME}/.local/bin" \
  "/usr/local/opt/coreutils/libexec/gnubin" \
)

mkdir -p "${HOME}/.local/bin"
mkdir -p "${HOME}/.local/opt/{bin,sbin}"

PATH="${PREPATHS}:${PATH}"

# Dedup paths
echo "dedupping and exporting PATH"
TMP_PATH=$(printf "%s" "${PATH}" | awk -v RS=: '{gsub(/\/$/,"")} !($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
export PATH="${TMP_PATH}"
unset TMP_PATH
echo "persisting PATH"
echo "PATH=${PATH}" > "${HOME}/.env_path"

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the parent has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

### variables used across the setup files
set -a
: "${DOTFILES_PATH:=${HOME}/.files}"
: "${TAGSRC:=${HOME}/.tagsrc}"
: "${SYSTEM:=$(getOS)}"
: "${ARCH:=$(getArch)}"
: "${TAGS:=$(getTags)}"
: "${WORK:=$(isWork)}"
: "${PERSONAL:=$(isPersonal)}"
: "${HOST:=$(hostname -s)}"
: "${PACKAGES_PATH:=${DOTFILES_PATH}/.setup.d/packages}"
set +a

echo "Dotfiles path: ${DOTFILES_PATH}"
echo "Packages path: ${PACKAGES_PATH}"
echo "System: ${SYSTEM}"
echo "Architecture: ${ARCH}"
echo "Tags: ${TAGS}"
echo "Is work? ${WORK}"
echo "Is personal? ${PERSONAL}"
echo "Host: ${HOST}"

### setup scripts
for setupd in .setup.d/*.sh; do
  # shellcheck disable=SC1090
  sh "${setupd}" "$@" || echo "${setupd} failed"
done

### platform-specitic setup scripts
if [ -d ".setup.d/${SYSTEM}" ]; then
  for setupd in .setup.d/"${SYSTEM}"/*.sh; do
    # shellcheck disable=SC1090
    sh "${setupd}" "$@" || echo "${setupd} failed"
  done
fi

printf "\e[1;34mMiscellaneous\e[0m\n"
# creates the control path folder for SSH
mkdir -p "${HOME}/.ssh/control"
# Update system font cache
if _=$(command -V fc-cache >/dev/null 2>&1); then
  printf "Updating font cache...\n"
  fc-cache -f &
fi
### Set fish paths
printf "Setting fish universal variables...\n"
fish ./variables.fish "${PATH}" || "failed to setup fish variables"

if _=$(command -V kquitapp5 >/dev/null 2>&1); then
  printf "Updating KDE globals...\n"
  kquitapp5 kglobalaccel && sleep 2s && kglobalaccel5 &
fi

printf "Reloading tmux configuration...\n"
tmux source-file "${HOME}/.tmux.conf"

printf "\e[1;34mCleanup\e[0m\n"

printf "Removing environment variables...\n"
for FILE in "${HOME}/.env_remove"*; do
  while IFS= read -r VARIABLE; do
    echo "Removing ${VARIABLE}..."
    unset "${VARIABLE}"
  done < "${FILE}"
done

printf "\e[1;32mDone!\e[0m\n"
