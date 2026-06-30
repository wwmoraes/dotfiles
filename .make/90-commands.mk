# The targets here imperative commands which are a misuse of Make; they should
# instead be ported somewhere else like nix apps or justfile.

define BACKUP_PATHS
$(strip
"${HOME}/.config"
"${HOME}/.docker"
"${HOME}/Library/Group Containers"
)
endef

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
