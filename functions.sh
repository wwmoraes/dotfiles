#!/bin/bash

getOS() {
  uname -s | tr '[:upper:]' '[:lower:]'
}

getArch() {
  case "$(uname -m | tr '[:upper:]' '[:lower:]')" in
    armv8)
      echo arm64
      ;;
    x86|386)
      echo 386
      ;;
    arm*)
      echo arm
      ;;
    x86_64|amd64|""|*)
      echo amd64
      ;;
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
