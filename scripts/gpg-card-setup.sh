#!/usr/bin/env sh

: "${USER_PIN:?must be set}"
: "${ADMIN_PIN:?must be set}"
: "${RESET_CODE:?must be set}"
: "${KEYID:?must be set}"

# echo "changing user PIN..."
# "${GPG}" --command-fd=0 --pinentry-mode=loopback --change-pin --status-fd 3 3>/dev/null <<EOF
# 1
# 123456
# $USER_PIN
# $USER_PIN
# quit
# EOF

# echo "changing admin PIN..."
# "${GPG}" --command-fd=0 --pinentry-mode=loopback --change-pin --status-fd 3 3>/dev/null <<EOF
# 3
# 12345678
# $ADMIN_PIN
# $ADMIN_PIN
# quit
# EOF

# echo "setting reset code..."
# "${GPG}" --command-fd=0 --pinentry-mode=loopback --change-pin --status-fd 3 3>/dev/null <<EOF
# 4
# $ADMIN_PIN
# $RESET_CODE
# $RESET_CODE
# quit
# EOF

# if "${GPG}" --card-status | grep 'Signature PIN' | grep -q 'not forced'; then
# echo "Enforcing signature PIN..."
# "${GPG}" --command-fd=0 --pinentry-mode=loopback --edit-card --status-fd 3 3>/dev/null <<EOF
# admin
# forcesig
# quit
# EOF
# fi

# echo "Changing key attributes..."
# "${GPG}" --command-fd=0 --pinentry-mode=loopback --edit-card --status-fd 3 3>/dev/null <<EOF
# admin
# key-attr
# 1
# 4096
# $ADMIN_PIN
# 1
# 4096
# 1
# 4096
# quit
# EOF

# echo "Adding signature key..."
# "${GPG}" --command-fd=0 --pinentry-mode=loopback --edit-key "${KEYID}" --status-fd 3 3>/dev/null <<EOF
# addcardkey
# 1
# $USER_PIN
# 0
# y
# y
# save
# EOF

# echo "Adding encryption key..."
# "${GPG}" --command-fd=0 --pinentry-mode=loopback --edit-key "${KEYID}" --status-fd 3 3>/dev/null <<EOF
# addcardkey
# 2
# $USER_PIN
# 0
# y
# y
# save
# EOF

# echo "Adding authentication key..."
# "${GPG}" --command-fd=0 --pinentry-mode=loopback --edit-key "${KEYID}" --status-fd 3 3>/dev/null <<EOF
# addcardkey
# 3
# $USER_PIN
# 0
# y
# y
# save
# EOF

# echo "Setting login data..."
# "${GPG}" --command-fd=0 --pinentry-mode=loopback --edit-card --status-fd 3 3>/dev/null <<EOF
# admin
# login
# $ACCOUNT_NAME
# $ADMIN_PIN
# quit
# EOF

# echo "Setting cardholder name..."
# "${GPG}" --command-fd=0 --pinentry-mode=loopback --edit-card --status-fd 3 3>/dev/null <<EOF
# admin
# name
# $SURNAME
# $GIVEN_NAME
# quit
# EOF

# echo "Setting language..."
# "${GPG}" --command-fd=0 --pinentry-mode=loopback --edit-card --status-fd 3 3>/dev/null <<EOF
# admin
# lang
# en
# $ADMIN_PIN
# quit
# EOF

# echo "Setting salutation..."
# "${GPG}" --command-fd=0 --pinentry-mode=loopback --edit-card --status-fd 3 3>/dev/null <<EOF
# admin
# salutation
# M
# quit
# EOF

# echo "Setting user interaction flags..."
# "${GPG}" --command-fd=0 --pinentry-mode=loopback --edit-card --status-fd 3 3>/dev/null <<EOF
# admin
# uif 1 on
# uif 2 on
# uif 3 on
# quit
# EOF

echo "Setting public key URL..."
"${GPG}" --command-fd=0 --pinentry-mode=loopback --edit-card --status-fd 3 3>/dev/null <<EOF
admin
url
${URL}
${ADMIN_PIN}
quit
EOF

FINGERPRINT=$(gpg --card-status | grep 'Authentication key' | grep -v '\[none\]' | cut -d' ' -f3-)
KEYGRIP=$(gpg --card-status | grep -A2 "${FINGERPRINT}" | grep keygrip | awk '{print $3}')
if test -n "${KEYGRIP}"; then
	echo "configuring authentication key for SSH"
	gpg-connect-agent "KEYATTR ${KEYGRIP} Use-for-ssh: true" /bye
	cat "${HOME}/.gnupg/private-keys-v1.d/${KEYGRIP}.key"
fi

if "${YKMAN}" openpgp info | grep "Signature key" | grep -q Cached; then
	echo "Set touch policy for signature key"
	"${YKMAN}" openpgp keys set-touch --force sig cached
fi

if "${YKMAN}" openpgp info | grep "Encryption key" | grep -q Cached; then
	echo "Set touch policy for encryption key"
	"${YKMAN}" openpgp keys set-touch --force enc cached
fi

if "${YKMAN}" openpgp info | grep "Authentication key" | grep -q Cached; then
	echo "Set touch policy for authentication key"
	"${YKMAN}" openpgp keys set-touch --force aut cached
fi

if "${YKMAN}" openpgp info | grep "Attestation key" | grep -q Cached; then
	echo "Set touch policy for attestation key"
	"${YKMAN}" openpgp keys set-touch --force att cached
fi

"${GPG}" --card-status
"${YKMAN}" openpgp info
