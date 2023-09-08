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

fixPath() {
  # System paths (FIFO)
  ### TODO use HOMEBREW_PREFIX to avoid duplicate path entries here
  PRE_PATH=$(join ":" \
    "${HOME}/.local/bin" \
    "/opt/homebrew/opt/coreutils/libexec/gnubin" \
    "/opt/homebrew/bin" \
    "/opt/homebrew/sbin" \
    "/usr/local/opt/coreutils/libexec/gnubin" \
    "/usr/local/bin" \
    "/usr/local/sbin"
  )

  POST_PATH=$(join ":" \
    "${HOME}/go/bin" \
    "${HOME}/.cargo/bin" \
    "${HOME}/.cabal/bin" \
    "${HOME}/.local/google-cloud-sdk/bin" \
    "${HOME}/.krew/bin" \
    "${HOME}/.config/yarn/global/node_modules/.bin"
  )

  if command -V python3 > /dev/null 2>&1; then
    PYTHON_PATH=$(python3 -m site --user-base)/bin
    POST_PATH=${PYTHON_PATH}:${POST_PATH}
  fi

  mkdir -p "${HOME}/.local/bin"
  rm -rf "${HOME}/.local/opt/bin"
  rm -rf "${HOME}/.local/opt/sbin"

  # remove pre- and post-paths from the existing path to ensure they are on the
  # right position

  PATH_LINES=$(mktemp)
  # shellcheck disable=SC2064
  trap "rm -f '${PATH_LINES}'" EXIT
  echo "${PATH}" | sed "s/:/\n/g" > "${PATH_LINES}"

  CLEAN_PATH=''
  while read -r DIR; do
    case "${PRE_PATH}:${POST_PATH}" in
      ${DIR}:*) ;;
      *:${DIR}:*) ;;
      *:${DIR}) ;;
     *) CLEAN_PATH=$(join ":" "${CLEAN_PATH}" "${DIR}");;
    esac
  done < "${PATH_LINES}"
  rm "${PATH_LINES}"

  PATH="${PRE_PATH}:${CLEAN_PATH#:*}:${POST_PATH}"

  REMOVE_PATH_LINES=$(mktemp)
  # shellcheck disable=SC2064
  trap "rm -f '${PATH_LINES}'" EXIT
  paths2remove > "${REMOVE_PATH_LINES}"

  # remove paths we don't want anymore
  while read -r ENTRY; do
    case "${PATH}" in
      ${ENTRY}:*) PATH=${PATH#*:};;
      *:${ENTRY}:*) PATH=$(echo "${PATH}" | sed "s#:${ENTRY}:#:#g");;
      *:${ENTRY}) PATH=${PATH%:*};;
      *);;
    esac
  done < "${REMOVE_PATH_LINES}"
  rm "${REMOVE_PATH_LINES}"

  # Dedup paths
  echo "dedupping and exporting PATH"
  TMP_PATH=$(printf "%s" "${PATH}" | awk -v RS=: '{gsub(/\/$/,"")} !($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
  export PATH="${TMP_PATH}"

  printf "updating launchctl paths...\n"
  launchctl setenv PATH "${PATH}"
  sudo launchctl config system path "${PATH}"
  sudo launchctl config user path "${PATH}"

  ### Set fish paths
  printf "Setting fish universal variables...\n"
  fish ./variables.fish "${PATH}" || "failed to setup fish variables"
}

paths2remove() {
  echo "${HOME}/Library/Python/3.9/bin"
  echo "${HOME}/Library/Python/3.10/bin"
  echo "${HOME}/go/bin/darwin_arm64"
  echo "${HOME}/go/bin/darwin_amd64"
  echo "${HOME}/.local/opt/bin"
  echo "${HOME}/.local/opt/sbin"
}
