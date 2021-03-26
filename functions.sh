#!/bin/sh

set -eum

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

isWork() {
  HOST=$(hostname -s)
  test "${HOST}" = "NLMBF04E-C82334" && echo 1 && return

  echo 0
}

isPersonal() {
  HOST=$(hostname -s)
  test "${HOST}" = "M1Cabuk" && echo 1 && return

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
