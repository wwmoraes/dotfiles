#!/usr/bin/env sh

set -eu

SECURITY=/usr/bin/security
KEYCHAINS="$(${SECURITY} list-keychains | xargs) /System/Library/Keychains/SystemRootCertificates.keychain"

WORKDIR=$(mktemp --directory)
# shellcheck disable=SC2064 # expanding now to store the path
trap "rm -rf '${WORKDIR}'" EXIT

VERIFIED_CERTS_BUNDLE=$(mktemp "${WORKDIR}/verified-bundle.XXXXXXXX")

echo "downloading base bundle..."

curl -fsSLo "${WORKDIR}/cacert.pem" https://curl.se/ca/cacert.pem
curl -fsSLo "${WORKDIR}/cacert.pem.sha256" https://curl.se/ca/cacert.pem.sha256

echo "checking bundle checksum..."

if ! _=$(cd "${WORKDIR}"; sha256sum --check cacert.pem.sha256); then
	echo >&2 "base CA bundle checksum doesn't match"
	exit 1
fi

cat "${WORKDIR}/cacert.pem" > "${VERIFIED_CERTS_BUNDLE}"

echo "verifying MacOS keychain certificates..."

# shellcheck disable=SC2086 # multiple paths, not a space/separated one
${SECURITY} find-certificate -a -p ${KEYCHAINS} | while read -r line; do
	case "${line}" in
		"-----BEGIN CERTIFICATE-----"|"-----BEGIN TRUSTED CERTIFICATE-----")
			CERT_FILE=$(mktemp "${WORKDIR}/cert.XXXXXXXX")
			echo "${line}" > "${CERT_FILE}"
			;;
		"-----END CERTIFICATE-----"|"-----END TRUSTED CERTIFICATE-----")
			echo "${line}" >> "${CERT_FILE}"
			if ${SECURITY} verify-cert -q -l -L -R offline -c "${CERT_FILE}"; then
				cat "${CERT_FILE}" >> "${VERIFIED_CERTS_BUNDLE}"
			else
				echo >&2 "skipping a certificate that didn't pass verification"
				cat "${CERT_FILE}" >&2
			fi
			;;
		*)
			echo "${line}" >> "${CERT_FILE}"
			;;
	esac
done

echo "installing new bundle..."

sudo cp /etc/ssl/cert.pem "/etc/ssl/cert.pem-$(date +"%s.%N")"
sudo cp "${VERIFIED_CERTS_BUNDLE}" /etc/ssl/cert.pem
