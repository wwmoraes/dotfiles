#!/bin/sh

set -eum

enterTmp() {
  TMP=$(mktemp -d)
  OLD_PWD="${PWD}"
  cd "${TMP}"
  trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT
  export TMP
}

getPackages() {
  if [ ! $# -eq 1 ]; then
    echo "usage: get_packages <package-file-name>" > /dev/fd/2
    exit 1
  fi

  : "${DOTFILES_PATH:=${HOME}/.files}"
  : "${PACKAGES_PATH:=${DOTFILES_PATH}/.setup.d/packages}"
  : "${TAGSRC:=${HOME}/.tagsrc}"

  # package file name
  PACKAGES_FILE_NAME="$1"
  PACKAGES_FILE_PATH="${PACKAGES_PATH}/${PACKAGES_FILE_NAME}"
  SYSTEM_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${SYSTEM}/${PACKAGES_FILE_NAME}"
  HOST_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${HOST}/${PACKAGES_FILE_NAME}"

  # wanted packages
  PACKAGES="$(mktemp -u "${PWD}"/packages.XXXXXX)"
  mkfifo "${PACKAGES}"

  # reads global packages
  if [ -f "${PACKAGES_FILE_PATH}" ]; then
    while IFS= read -r LINE; do
      echo "${LINE}" | grep -Eq "^#" && continue
      printf "%s\n" "${LINE}" > "${PACKAGES}" &
    done < "${PACKAGES_FILE_PATH}"
  fi

  # reads system-specific packages
  if [ -f "${SYSTEM_PACKAGES_FILE_PATH}" ]; then
    while IFS= read -r LINE; do
      echo "${LINE}" | grep -Eq "^#" && continue
      printf "%s\n" "${LINE}" > "${PACKAGES}" &
    done < "${SYSTEM_PACKAGES_FILE_PATH}"
  fi

  # reads tag-specific packages
  while IFS= read -r TAG; do
    TAG_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${TAG}/${PACKAGES_FILE_NAME}"

    test -f "${TAG_PACKAGES_FILE_PATH}" || continue

    while IFS= read -r LINE; do
      echo "${LINE}" | grep -Eq "^#" && continue
      printf "%s\n" "${LINE}" > "${PACKAGES}" &
    done < "${TAG_PACKAGES_FILE_PATH}"
  done < "${TAGSRC}"

  # reads host-specific packages
  if [ -f "${HOST_PACKAGES_FILE_PATH}" ]; then
    while IFS= read -r LINE; do
      echo "${LINE}" | grep -Eq "^#" && continue
      printf "%s\n" "${LINE}" > "${PACKAGES}" &
    done < "${HOST_PACKAGES_FILE_PATH}"
  fi

  export PACKAGES
}

join() { IFS="$1"; shift; echo "$*"; }
