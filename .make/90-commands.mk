# The targets here imperative commands which are a misuse of Make; they should
# instead be ported somewhere else like nix apps or justfile.

define BACKUP_PATHS
$(strip
"${HOME}/.config"
"${HOME}/.docker"
"${HOME}/Library/Group Containers"
)
endef

.PHONY: fix
#: Corrects nix store paths in single-user installations.
fix:
	tree -ifpug /nix | awk '$$2 != "william" {print $$8}' | xargs -I% sudo chown -R william:_developer '%'
	sudo chmod ug+s /nix /nix/store /nix/var
	tree -ifpug /nix | grep -- 'dr-xr-xr-x' | awk '{print $$8}' | xargs -I% chmod ug+s '%'

.PHONY: rm-backups
#: Removes backup files interactively.
rm-backups:
	@fd "" ${BACKUP_PATHS} --hidden --no-ignore --type f --extension bkp --exec echo {.} \
	| fzf -m --preview 'diff --text --unified {} {}.bkp' \
	| ifne xargs -I% rm '%.bkp'

.PHONY: rm-json-backups
#: Removes JSON backup files interactively.
rm-json-backups:
	@fd "" ${BACKUP_PATHS} --hidden --no-ignore --type f --extension json.bkp --exec echo {.} \
	| fzf -m --preview 'jd -set {} {}.bkp' \
	| ifne xargs -I% rm '%.bkp'

.PHONY: diff-json-backups
#: Shows the difference between backed-up and current JSON files.
diff-json-backups:
	@fd "" ${BACKUP_PATHS} --hidden --no-ignore --type f --extension json.bkp --exec echo {.} \
	| fzf --preview 'jd -set {} {}.bkp' \
	| ifne xargs -I% jd -set '%' '%.bkp'

.PHONY: setup-card
setup-card:
	# op run --env-file=scripts/gpg-card-setup.env -- sh scripts/gpg-card-setup.sh
	nix run nixpkgs#yubikey-manager -- openpgp keys set-touch --force att cached
	nix run nixpkgs#yubikey-manager -- openpgp keys set-touch --force aut cached
	nix run nixpkgs#yubikey-manager -- openpgp keys set-touch --force enc cached
	nix run nixpkgs#yubikey-manager -- openpgp keys set-touch --force sig cached
	nix run nixpkgs#yubikey-manager -- openpgp info
	nix run nixpkgs#yubikey-manager -- openpgp keys info att
	nix run nixpkgs#yubikey-manager -- openpgp keys info aut
	nix run nixpkgs#yubikey-manager -- openpgp keys info enc
	nix run nixpkgs#yubikey-manager -- openpgp keys info sig
	# enables retired key management slots (0x82-0x95)
	# see https://github.com/OpenSC/OpenSC/issues/847#issuecomment-238119888
	nix-shell -p yubico-piv-tool --command 'echo -n C10114C20100FE00 | yubico-piv-tool -k -a write-object --id 0x5FC10C -i -'

## overkill solution when changing undocumented preferences goes awfully wrong
.PHONY: macos-fix
macos-fix:
ifeq ($(shell uname -s),Darwin)
	rm -rfv ~/Library/Application\ Scripts/com.apple.systempreferences.* || true
	rm -rfv ~/Library/Caches/com.apple.preferencepanes.usercache || true
	rm -rfv ~/Library/Caches/com.apple.systempreferences || true
	rm -rfv ~/Library/Caches/com.apple.systemsettings.menucache || true
	rm -rfv ~/Library/Containers/com.apple.systempreferences* || true
	rm -rfv ~/Library/Group\ Containers/com.apple.systempreferences.* || true
	rm -rfv ~/Library/Preferences/com.apple.systempreferences.plist || true
	rm -rfv ~/Library/Preferences/com.apple.systemsettings.extensions.plist || true
	rm -rfv ~/Library/Saved\ Application\ State/com.apple.systempreferences.savedState || true
	sudo rm -rfv /Library/Caches/com.apple.iconservices.store || true
	killall cfprefsd
	/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
else
	$(info this isn't a Darwin system, nothing to do)
endif

.PHONY: validate-secrets
validate-secrets:
ifeq ($(shell command -v op),)
	@echo "1password CLI not found, skipping validation"
else
	@gron secrets.yaml.gotmpl \
	| grep "op://" \
	| sed 's/[";]//g' \
	| xargs -P 0 -I% bash -c 'echo "%" | op inject > /dev/null || echo %'
endif

