#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"
: "${PACKAGES_PATH:?must be set}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# create temp work dir and traps cleanup
TMP=$(mktemp -d)
OLD_PWD="${PWD}"
cd "${TMP}"
trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT

### setup
PACKAGES_FILE_NAME=code.txt
PACKAGES_FILE_PATH="${PACKAGES_PATH}/${PACKAGES_FILE_NAME}"

# wanted packages
PACKAGES="${TMP}/packages"
mkfifo "${PACKAGES}"

printf "\e[1;34mVSCodium setup\e[0m\n"

## configure marketplace on codium (open VSX is still lacking behind)
CODIUM_RESOURCES_PATH=
case "${SYSTEM}" in
  "linux") CODIUM_RESOURCES_PATH=/usr/share/codium/resources;;
  "darwin")
    BUNDLE_PATH=$(lsappinfo info -only bundlepath com.visualstudio.code.oss |\
      cut -d= -f2 | xargs)
    CODIUM_RESOURCES_PATH="${BUNDLE_PATH}/Contents/Resources";;
  "*") echo "unsupported system ${SYSTEM}"; exit 1;;
esac

PRODUCT_JSON_PATH=
if [ -n "${CODIUM_RESOURCES_PATH}" ]; then
  PRODUCT_JSON_PATH="${CODIUM_RESOURCES_PATH}/app/product.json"
fi

JQ_FILTER=""
while IFS="" read -r line; do
  JQ_FILTER="$(printf "%s\n%s" "${JQ_FILTER}" "${line}" | grep .)"
done <<\EOF
.
| .extensionsGallery.serviceUrl = $serviceUrl
| .extensionsGallery.itemUrl = $itemUrl
| .extensionsGallery.cacheUrl = $cacheUrl
EOF

echo "checking if VSCodium is installed..."
if [ -n "${PRODUCT_JSON_PATH}" ] && [ -f "${PRODUCT_JSON_PATH}" ]; then
  echo "changing VSCodium extensions gallery to MSFT Marketplace..."
  VSX_SERVICE_URL="https://marketplace.visualstudio.com/_apis/public/gallery"
  VSX_CACHE_URL="https://vscode.blob.core.windows.net/gallery/index"
  VSX_ITEM_URL="https://marketplace.visualstudio.com/items"
  jq \
    --arg serviceUrl "${VSX_SERVICE_URL}" \
    --arg itemUrl "${VSX_ITEM_URL}" \
    --arg cacheUrl "${VSX_CACHE_URL}" \
    "${JQ_FILTER}" \
    "${PRODUCT_JSON_PATH}" | ifne sponge "${PRODUCT_JSON_PATH}"
else
  echo "VSCodium not found, skipping"
fi

printf "\e[1;34mCode extensions\e[0m\n"

# reads wanted packages
while IFS= read -r LINE; do
  printf "%s\n" "${LINE}" > "${PACKAGES}" &
done <"${PACKAGES_FILE_PATH}"

### Check code
CODE=$(command -v codium 2> /dev/null || command -v code 2> /dev/null || command -v code-oss 2> /dev/null || echo "")
if [ "${CODE}" = "" ]; then
  echo "code not found"
  exit 1
fi

INSTALLED="${TMP}/installed"
"${CODE}" --list-extensions | tr '[:upper:]' '[:lower:]' > "${INSTALLED}"

# disable the annoying node deprecation warnings
NODE_NO_WARNINGS=1
export NODE_NO_WARNINGS

while read -r PACKAGE; do
  printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE}"
  grep -q "${PACKAGE}" "${INSTALLED}" && continue

  printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE}"
  "${CODE}" --install-extension "${PACKAGE}"
done < "${PACKAGES}"
