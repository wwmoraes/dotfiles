#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

### setup
PACKAGES_FILE_NAME=packages/rust.txt

### magic block :D
DIRNAME=$(perl -MCwd -e 'print Cwd::abs_path shift' "$0" | xargs dirname)
# Checks and sets the file path corretly if running directly or sourced
if [ "$0" == "${BASH_SOURCE[0]}" ]; then
  PACKAGES_FILE_PATH="${DIRNAME}/${PACKAGES_FILE_NAME}"
else
  PACKAGES_FILE_PATH="${DIRNAME}/${BASH_SOURCE%%/*}/${PACKAGES_FILE_NAME}"
fi

PACKAGES=()
while IFS= read -r line; do
   PACKAGES+=("${line}")
done <"${PACKAGES_FILE_PATH}"

printf "\e[1;33mRust packages\e[0m\n"

### Check package tool
echo "Checking rustup..."
# Get manager
if ! _=$(type -p rustup &> /dev/null); then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

echo "Checking rust components..."
WANTED_COMPONENTS=(
  rust-analysis
  rust-src
  rls
)

TARGET=$(rustup target list 2>&1 | awk '/(installed)/ {print $1}' | head -n1)
INSTALLED_COMPONENTS=$(rustup component list 2>&1 | awk '/(installed)/ {print $1}' | sed "s/-${TARGET}//")

for COMPONENT in "${WANTED_COMPONENTS[@]}"; do
  printf "%s\n" "${INSTALLED_COMPONENTS[@]}" | grep -q "${COMPONENT}" || {
    printf "Installing \e[96m%s\e[0m...\n" "${COMPONENT}"
    rustup component add "${COMPONENT}" --target "${TARGET}"
  }
done

echo "Checking for rust packages..."

### Install packages
for PACKAGE in "${PACKAGES[@]+${PACKAGES[@]}}"; do
  printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE%%:*}"
  type -p "${PACKAGE##*:}" &> /dev/null && type -p "${HOME}/.cargo/bin/${PACKAGE##*:}" &> /dev/null && continue

  printf "Installing \e[96m%s\e[0m on background...\n" "${PACKAGE%%:*}"
  cargo -q install "${PACKAGE%%:*}" > /dev/null &
done
