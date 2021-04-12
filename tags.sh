#!/bin/sh

: "${TAGSRC:=${HOME}/.tagsrc}"

usage() {
  echo "usage: $0 get"
  echo "usage: $0 set <tag1>[ <tagN>]"
  echo "usage: $0 add <tag1>[ <tagN>]"
  echo "usage: $0 remove <tag>"
  echo "usage: $0 contains <tag>"
  echo "usage: $0 usage"
  exit "${1:-2}"
}

if [ $# -lt 1 ]; then
  usage 2
fi

touch "${TAGSRC}"

CMD=$1
shift

case "${CMD}" in
  "get"|"") cat "${TAGSRC}";;
  "set") echo "$@" | awk -v RS=' ' '{print}' | tee "${TAGSRC}";;
  "add")
    TAGS=$(echo "$@" | cat - "${TAGSRC}" | sort | uniq)
    echo "${TAGS}" | tee "${TAGSRC}";;
  "remove")
    IFS='|'
    TAGS=$(grep -vE "^($*)$" "${TAGSRC}")
    echo "${TAGS}" | tee "${TAGSRC}";;
  "contains") grep -qFx "$1" "${TAGSRC}";;
  "usage") usage 0;;
  *) usage;;
esac
