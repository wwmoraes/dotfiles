#!/usr/bin/env sh

# creates and changes the current directory to a temporary one.
# Traps on EXIT the cleanup and return to the previous directory
createAndEnterTmpDir() {
  TMP=$(mktemp -d)
  OLD_PWD="${PWD}"
  cd "${TMP}" || exit
  trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT
}

getRandomFifo() {
  FIFO=$(mktemp -u -t functions-getRandomFifo-XXXXXX)
  mkfifo -m 0600 "${FIFO}"
  trap 'rm -f "${FIFO}"' EXIT INT TERM

  echo "${FIFO}"
}

# creates a FIFO pipe that provides the package names of the target type. The
# path to the pipe is set on PACKAGES or on the optional variable name provided.
# It reads and forwards the package names in the background
getPackagesPipeIntoVariable() {
  if [ ! $# -eq 2 ]; then
    echo "usage: getPackagesPipeIntoVariable <package-file-name> <target=variable-name>" > /dev/fd/2
    return 1
  fi

  PACKAGES="$(mktemp -u "${PWD}/packages.XXXXXX")"
  mkfifo "${PACKAGES}"

  listPackages "$1" > "${PACKAGES}" &

  eval "$2=${PACKAGES}"
}

# synchronously reads packages and print them
listPackages() {
  if [ ! $# -eq 1 ]; then
    echo "usage: listPackages <package-file-name>" > /dev/fd/2
    return 1
  fi

  : "${HOST:?unknown system}"
  : "${SYSTEM:?unknown system}"

  : "${DOTFILES_PATH:=${HOME}/.files}"
  : "${PACKAGES_PATH:=${DOTFILES_PATH}/.setup.d/packages}"
  : "${TAGSRC:=${HOME}/.tagsrc}"

  # package file name
  PACKAGES_FILE_NAME="$1"
  PACKAGES_FILE_PATH="${PACKAGES_PATH}/${PACKAGES_FILE_NAME}"
  SYSTEM_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${SYSTEM}/${PACKAGES_FILE_NAME}"
  HOST_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${HOST}/${PACKAGES_FILE_NAME}"

  # reads global packages
  if [ -f "${PACKAGES_FILE_PATH}" ]; then
    while IFS= read -r LINE; do
      echo "${LINE}" | grep -Eq "^#" && continue
      printf "%s\n" "${LINE}"
    done < "${PACKAGES_FILE_PATH}"
  fi

  # reads system-specific packages
  if [ -f "${SYSTEM_PACKAGES_FILE_PATH}" ]; then
    while IFS= read -r LINE; do
      echo "${LINE}" | grep -Eq "^#" && continue
      printf "%s\n" "${LINE}"
    done < "${SYSTEM_PACKAGES_FILE_PATH}"
  fi

  # reads tag-specific packages
  while IFS= read -r TAG; do
    TAG_PACKAGES_FILE_PATH="${PACKAGES_PATH}/${TAG}/${PACKAGES_FILE_NAME}"

    test -f "${TAG_PACKAGES_FILE_PATH}" || continue

    while IFS= read -r LINE; do
      echo "${LINE}" | grep -Eq "^#" && continue
      printf "%s\n" "${LINE}"
    done < "${TAG_PACKAGES_FILE_PATH}"
  done < "${TAGSRC}"

  # reads host-specific packages
  if [ -f "${HOST_PACKAGES_FILE_PATH}" ]; then
    while IFS= read -r LINE; do
      echo "${LINE}" | grep -Eq "^#" && continue
      printf "%s\n" "${LINE}"
    done < "${HOST_PACKAGES_FILE_PATH}"
  fi
}

join() { IFS="$1"; shift; echo "$*"; }
splitOnce() {
  IFS="$1"
  shift

  LEFT="${1%%"${IFS}"*}"
  RIGHT="${1##*"${IFS}"}"

  echo "${LEFT} ${RIGHT}"
}

splitOnceByInto() {
  IFS="$1"; shift
  LEFT_VAR="$1"; shift
  RIGHT_VAR="$1"; shift
  VALUE="$*"

  LEFT="${VALUE%%"${IFS}"*}"
  RIGHT="${VALUE##*"${IFS}"}"
  test "${RIGHT}" = "${LEFT}" && unset RIGHT

  eval "${LEFT_VAR}=${LEFT}"
  eval "${RIGHT_VAR}=${RIGHT:-}"
}

parsePackageForRemoval() {
  case "${1%%:*}" in
    -*) echo "1 ${1#-*}";;
    *) echo "0 $1";;
  esac
}

FgColorBlack=$(printf '\e[90m')
FgColorRed=$(printf '\e[91m')
FgColorGreen=$(printf '\e[92m')
FgColorYellow=$(printf '\e[93m')
FgColorBlue=$(printf '\e[94m')
FgColorMagenta=$(printf '\e[95m')
FgColorCyan=$(printf '\e[96m')
FgColorWhite=$(printf '\e[97m')
ResetColors=$(printf '\e[m')
EraseCursorToEOL=$(printf '\033[0K')

withColor() { color="$1"; shift; printf "%s%s%s" "${color}" "$*" "${ResetColors}"; }
colorPath() { withColor "${FgColorBlue}" "$*"; }
colorBin() { withColor "${FgColorRed}" "$*"; }

printLn() { printf "%s\n" "$*"; }
reprintLn() { printf "%s%s\r" "$*" "${EraseCursorToEOL}"; }

h1() { printLn "$(withColor "${FgColorYellow}" "$*")"; }
h2() { printLn "$(withColor "${FgColorBlue}" "$*")"; }
h3() { printLn "$(withColor "${FgColorMagenta}" "$*")"; }

printStatus() {
  case "$1" in
  "install") GROUP=$(withColor "${FgColorWhite}" "  install  ");;
  "uninstall") GROUP=$(withColor "${FgColorBlack}" " uninstall ");;
  esac
  shift

  case "$1" in
  "check")
    GROUP=$(withColor "${FgColorBlack}" "${GROUP}")
    MESSAGE="🔎"
    FN="reprintLn"
    ;;
  "execute")
    GROUP=$(withColor "${FgColorBlack}" "${GROUP}")
    MESSAGE="⏳"
    FN="printLn"
    ;;
  "failure")
    GROUP=$(withColor "${FgColorRed}" "${GROUP}")
    MESSAGE="❌"
    FN="printLn"
    ;;
  "skip"|"success")
    GROUP=$(withColor "${FgColorGreen}" "${GROUP}")
    MESSAGE="✅"
    FN="printLn"
    ;;
  esac
  shift

  __PACKAGE=$(withColor "${FgColorCyan}" "$*")
  "${FN}" "$(printf "[%s] %s %s" "${GROUP}" "${MESSAGE}" "${__PACKAGE}")"
}

printCheckingBinary() { printf "Checking %s...\n" "$(colorBin "$1")"; }
