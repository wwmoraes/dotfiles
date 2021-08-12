#!/bin/sh

set -eum

: "${TAGSRC:=${HOME}/.tagsrc}"

getOS() {
  uname -s | tr '[:upper:]' '[:lower:]'
}

getArch() {
  OS=$(getOS)
  if [ "${OS}" = "darwin" ]; then
    # use the sysctl brand info set by the mach kernel on MacOS
    case "$(sysctl -qn machdep.cpu.brand_string)" in
      "Apple M1")
        ARCH=arm64e;;
      Intel*)
        ARCH=x86_64;;
      ""|*)
        ARCH=unknown;;
    esac
  elif [ "${OS}" = "linux" ] && _=$(command -V lscpu >/dev/null 2>&1); then
    ARCH=$(lscpu | awk '$1 == "Architecture:" {print $2}' | tr '[:upper:]' '[:lower:]')
  else
    # very unreliable, as uname will output the architecture it was built and
    # ran with, e.g. MacOS emulated architectures (such as PowerPC, when
    # migrated to Intel, or Intel, when migrated to ARM)
    ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')
  fi

  case "${ARCH}" in
    armv8|arm64*|aarch64*)
      echo arm64;;
    x86_64|amd64)
      echo amd64;;
    x86|386)
      echo 386;;
    arm*)
      echo arm;;
    ""|*)
      echo "${ARCH}";;
  esac
}

getTags() {
  test -f "${TAGSRC}" || return 0
  cat "${TAGSRC}"
}

isTagged() {
  test $# -gt 0 || return 2
  test -f "${TAGSRC}" || return 1
  grep -qFx "$1" "${TAGSRC}"
}

isWork() {
  isTagged work && echo 1 && return
  echo 0
}

isPersonal() {
  isTagged personal && echo 1 && return
  echo 0
}

sourceFiles() {
  for file in "$@"; do
    # skip if file does not exist
    test ! -e "${file}" && return

    # skip if file is not readable
    test ! -r "${file}" && return

    # Source them to update context
    # shellcheck disable=SC1090
    . "${file}"
  done
}

join() { IFS="$1"; shift; echo "$*"; }

enterTmp() {
  TMP=$(mktemp -d)
  OLD_PWD="${PWD}"
  cd "${TMP}"
  trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT
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
