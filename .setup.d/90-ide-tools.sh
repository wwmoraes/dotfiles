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
PACKAGES_FILE_NAME=vscode.txt
PACKAGES_FILE_PATH="${PACKAGES_PATH}/${PACKAGES_FILE_NAME}"

# wanted packages
PACKAGES="${TMP}/packages"
mkfifo "${PACKAGES}"

# reads wanted packages
while IFS= read -r LINE; do
  printf "%s\n" "${LINE}" > "${PACKAGES}" &
done <"${PACKAGES_FILE_PATH}"

printf "\e[1;34mVSCode extensions\e[0m\n"

### Check vscode
VSCODE=$(command -v codium 2> /dev/null || command -v code 2> /dev/null || command -v code-oss 2> /dev/null || echo "")
if [ "${VSCODE}" = "" ]; then
  echo "code not found"
  exit 1
fi

## configure marketplace on codium (open VSX is still lacking behind)
CODIUM_RESOURCES_PATH=
case "${SYSTEM}" in
  "linux") CODIUM_RESOURCES_PATH=/usr/share/codium/resources;;
  "darwin")
    local BUNDLE_PATH=$(lsappinfo info -only bundlepath com.visualstudio.code.oss |\
      cut -d= -f2 | xargs)
    CODIUM_RESOURCES_PATH="${BUNDLE_PATH}/Contents/Resources";;
  "*") echo "unsupported system ${SYSTEM}"; exit 1;;
esac
PRODUCT_JSON_PATH="${CODIUM_RESOURCES_PATH}/app/product.json"

IFS='' read -d '' -r JQ_FILTER <<EOF
.
| .extensionsGallery.serviceUrl = \$serviceUrl
| .extensionsGallery.itemUrl = \$itemUrl
| .extensionsGallery.cacheUrl = \$cacheUrl
EOF

if [ -f "${PRODUCT_JSON_PATH}" ]; then
  echo "changing VSCodium extensions gallery to MSFT Marketplace..."
  local VSX_SERVICE_URL="https://marketplace.visualstudio.com/_apis/public/gallery"
  local VSX_CACHE_URL="https://vscode.blob.core.windows.net/gallery/index"
  local VSX_ITEM_URL="https://marketplace.visualstudio.com/items"
  jq \
    --arg serviceUrl "${VSX_SERVICE_URL}" \
    --arg itemUrl "${VSX_ITEM_URL}" \
    --arg cacheUrl "${VSX_CACHE_URL}" \
    "${JQ_FILTER}" \
    "${PRODUCT_JSON_PATH}" | ifne sponge "${PRODUCT_JSON_PATH}"
fi

INSTALLED="${TMP}/installed"
"${VSCODE}" --list-extensions | tr '[:upper:]' '[:lower:]' > "${INSTALLED}"

while read -r PACKAGE; do
  printf "Checking \e[96m%s\e[0m...\n" "${PACKAGE}"
  grep -q "${PACKAGE}" "${INSTALLED}" && continue

  printf "Installing \e[96m%s\e[0m...\n" "${PACKAGE}"
  "${VSCODE}" --install-extension "${PACKAGE}"
done < "${PACKAGES}"
