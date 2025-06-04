#!/usr/bin/env sh

set -eu

## dump certificates from OS keychains for a one-off use
TMP_CA_BUNDLE=$(mktemp bootstrap-ca-bundle.XXXXXXXX)

trap 'rm "${TMP_CA_BUNDLE}"' EXIT

## start with the current bundles
cat /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert.pem > "${TMP_CA_BUNDLE}"

KEYCHAINS=$(cat <<EOF
$(security list-keychains | xargs -n1)
/System/Library/Keychains/SystemRootCertificates.keychain
EOF
)

for keychain in ${KEYCHAINS}; do
	test -f "${keychain}" || continue

	## append all certificates from the OS keychain
	security find-certificate -a -p "${keychain}" >> "${TMP_CA_BUNDLE}"
done

cp "${TMP_CA_BUNDLE}" ca-bundle.pem

## use the temporary bundle for everything we can think of, just in case
export CURL_CA_BUNDLE="${TMP_CA_BUNDLE}" # libcurl
export GIT_SSL_CAINFO="${TMP_CA_BUNDLE}" # git
export NIX_GIT_SSL_CAINFO="${TMP_CA_BUNDLE}" # nix's git
export NIX_SSL_CERT_FILE="${TMP_CA_BUNDLE}" # nix's OpenSSL
export NODE_EXTRA_CA_CERTS="${TMP_CA_BUNDLE}" # node.js
export REQUESTS_CA_BUNDLE="${TMP_CA_BUNDLE}" # python's requests package
export SSL_CERT_FILE="${TMP_CA_BUNDLE}" # OpenSSL
export SYSTEM_CERTIFICATE_PATH="${TMP_CA_BUNDLE}" # Haskell & BSD stuff

HOSTNAME=$(scutil --get LocalHostName)

systemPath=$(nix build \
	--impure \
	--option ssl-cert-file "${TMP_CA_BUNDLE}" \
	--extra-experimental-features nix-command \
	--extra-experimental-features flakes \
	--option accept-flake-config true \
	--option build-users-group '""' \
	--print-out-paths \
	--no-link \
	.#darwinConfigurations."${HOSTNAME}".system \
;)

echo "system path: ${systemPath}"
sudo "${systemPath}/activate"

# sudo nix --option ssl-cert-file /etc/ssl/cert.pem --option accept-flake-config true run .#darwin-rebuild -- switch --impure --no-remote --flake .
