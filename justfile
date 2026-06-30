# https://just.systems

set quiet

HOSTNAME := shell("uname -n")
WORK_HOSTNAME := "NLLM4000559023"
OP := if shell("which op") != "" { "op plugin run --" } else { "" }

_default:
	echo "Make targets:"
	remake --tasks
	echo "Imperative tasks:"
	just --list --list-heading '' --list-prefix ''

[group('nix')]
[doc('Runs nixos-anywhere to install NixOS on the target system.')]
remote-install-nixos HOSTNAME SSH_TARGET:
	nix run github:nix-community/nixos-anywhere -- \
		--flake .#{{ HOSTNAME }} \
		--generate-hardware-config nixos-generate-config ./modules/hosts/{{ HOSTNAME }}/_hardware-configuration.nix \
		--target-host '{{ SSH_TARGET }}'

# Fetches the latest visudo derivation from the binary cache.
#
# In practice this isn't needed as nix does check the substituters first before
# trying to build from source.
#
# Sometimes I forget/CI takes a while to push a binary cache update before
# trying to re-apply the configuration @ work; this leads to a situation
# where the substitution fails, caching that result for hours before trying to
# build from source. Since my work environment does not allow connections to
# https://git.sudo.ws, I cannot build from source; thus it ends in a soft-locked
# state for the duration of that cache to retry the substitution again.
#
# This brute-force option restores the store path from the binary cache
# directly, which nix detects and skips the source build.

[group('work')]
[doc('Out-of-band visudo package handling. Necessary in dumb corporate environments. Pulls package from cache.')]
visudo-pull:
	#!/usr/bin/env bash
	OUT=$(nix eval --raw .#darwinConfigurations.{{ WORK_HOSTNAME }}.pkgs.nur.repos.wwmoraes.visudo.outPath)
	NARHASH=$(echo "${OUT}" | xargs basename | cut -d- -f1)
	curl -fsSLo - https://wwmoraes.cachix.org/${NARHASH}.narinfo \
	| grep '^URL:' \
	| cut -d' ' -f2 \
	| xargs -I% curl -fsSLo - https://wwmoraes.cachix.org/% \
	| zstdcat \
	| nix-store --restore "${OUT}"
	; nix-store --repair-path "${OUT}"

[group('work')]
[doc('Out-of-band visudo package handling. Necessary in dumb corporate environments. Builds and pushes to cache.')]
visudo-push:
	#!/usr/bin/env bash
	OUT=$(nix eval --raw .#darwinConfigurations.{{ WORK_HOSTNAME }}.pkgs.nur.repos.wwmoraes.visudo.outPath)
	NARHASH=$(echo "${OUT}" | xargs basename | cut -d- -f1)
	nom build --no-link --accept-flake-config --print-out-paths .#darwinConfigurations.{{ WORK_HOSTNAME }}.pkgs.nur.repos.wwmoraes.visudo \
	| {{ OP }} cachix push wwmoraes

[group('nix')]
[doc('Corrects nix store paths in single-user installations.')]
fix:
	tree -ifpug /nix | awk '$2 != "william" {print $8}' | xargs -I% sudo chown -R william:_developer '%'
	sudo chmod ug+s /nix /nix/store /nix/var
	tree -ifpug /nix | grep -- 'dr-xr-xr-x' | awk '{print $8}' | xargs -I% chmod ug+s '%'

[group('yubikey')]
[doc('Configures yubikey.')]
setup-yubikey:
	#!/usr/bin/env nix-shell
	#! nix-shell -i bash --packages yubikey-manager yubico-piv-tool
	# op run --env-file=scripts/gpg-card-setup.env -- sh scripts/gpg-card-setup.sh

	echo "setting touch policies"
	ykman openpgp keys set-touch --force att cached
	ykman openpgp keys set-touch --force aut cached
	ykman openpgp keys set-touch --force enc cached
	ykman openpgp keys set-touch --force sig cached

	echo "retrieving info"
	ykman openpgp info
	ykman openpgp keys info att
	ykman openpgp keys info aut
	ykman openpgp keys info enc
	ykman openpgp keys info sig

	# enables retired key management slots (0x82-0x95)
	# see https://github.com/OpenSC/OpenSC/issues/847#issuecomment-238119888
	echo "enabling retired key management slots"
	echo -n C10114C20100FE00 | yubico-piv-tool -k -a write-object --id 0x5FC10C -i -
