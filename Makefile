MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
.SHELLFLAGS := -euc
export SHELL := $(shell which bash)

.SUFFIXES:

HOSTNAME ?= $(shell uname -n)

define RM_RECURSIVE
$(strip
~/.adr
~/.config/chezmoi
~/.config/environment.rm.conf
~/.config/git/aliases
~/.config/git/colors
~/.config/git/home
~/.config/git/home-roaming
~/.config/git/work
~/.config/hub
~/.config/nixpkgs/config.nix
~/.config/projects.json
~/.config/smug
~/.config/sudoers.d
~/.lesshst
~/.lesskey
~/.local/hooks
~/.local/share/karabiner
~/.mosint.yaml
~/.nixpkgs
~/.profile
~/.ssh/config.d
~/.zcompdump
~/.zshenv
~/.zshrc
)
endef

define RMDIRS
$(strip
~/.config/*
~/.local/*
~/.local/share/*
)
endef

define BACKUP_PATHS
$(strip
"${HOME}/.config"
"${HOME}/.docker"
"${HOME}/Library/Group Containers"
)
endef

-include .make/*.mk

.DEFAULT_GOAL := host/${HOSTNAME}

.PHONY: all
#: Build all hosts' activation scripts.
all: host/M1Cabuk host/NLLM4000559023 host/vidar

.PHONY: build
#: Build current host's activation script.
build: host/${HOSTNAME}

.PHONY: check
#: Validates repository source halthiness.
check:
	@gitleaks dir --redact --verbose --no-banner
	@./.git/hooks/pre-commit

.PHONY: clean
#: Removes generated content.
clean:
	-rm -rf ${RM_RECURSIVE} 2> /dev/null
	-rmdir --parents ${RMDIRS} 2> /dev/null

.PHONY: configure
#: Sets up repository for contribution.
configure:
	git config --local include.path ../.gitconfig
	@rm .git/hooks/* || true
	cog install-hook --all --overwrite

.PHONY: fix
#: Corrects nix store paths in single-user installations.
fix:
	tree -ifpug /nix | awk '$$2 != "william" {print $$8}' | xargs -I% sudo chown -R william:_developer '%'
	sudo chmod ug+s /nix /nix/store /nix/var
	tree -ifpug /nix | grep -- 'dr-xr-xr-x' | awk '{print $$8}' | xargs -I% chmod ug+s '%'

.PHONY: install
#: Applies the current host's settings.
install: host/${HOSTNAME}
## why? because "enterprise-grade" environments fuck up SSL and nixpkgs
## somehow that is not really worth my time
ifeq (${HOSTNAME},NLLM4000559023)
	sudo .roots/NLLM4000559023/activate
else
	sudo darwin-rebuild switch --no-remote ${FLAGS} --flake .
endif

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

.PHONY: darwin/%
#: Applies the target host settings.
darwin/%: secrets.yaml
	@git add -N hosts modules overlays scripts settings users
	@mkdir -p .roots
	nix build --show-trace --accept-flake-config --out-link .roots/$* .#darwinConfigurations.$*.config.system.build.toplevel

.PHONY: nixos/%
#: Applies the target host settings.
nixos/%: secrets.yaml
	@git add -N hosts modules overlays scripts settings users
	@mkdir -p .roots
	nix build --show-trace --accept-flake-config --out-link .roots/$* .#nixosConfigurations.$*.config.system.build.toplevel

vm/%: secrets.yaml
	nix build --show-trace --accept-flake-config --out-link .roots/$*-vm .#legacyPackages.$(shell nix eval --raw .#nixosConfigurations.$*.config.nixpkgs.stdenv.hostPlatform.system).$*-vm

#: Applies vidar's settings over SSH.
vidar:
	nix run nixpkgs#nixos-rebuild -- switch \
		--build-host root@vidar.home.arpa \
		--fast \
		--flake .#vidar \
		--target-host root@vidar.home.arpa \
		;

secrets.yaml: secrets.yaml.gotmpl
ifeq ($(shell command -v op),)
	@echo "1password not found, skipping secrets update"
else
	@op inject --force --in-file $< | ifne sops encrypt --filename-override $@ --output $@
endif

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

define hostTarget
$(eval
#: Builds the target host's activation script.
host/$(2): $(1)/$(2);
)
endef

.PHONY: host/%

$(foreach HOST,$(shell nix eval --raw --apply 'v: builtins.toString (builtins.attrNames v)' .#darwinConfigurations),$(call hostTarget,darwin,${HOST}))
$(foreach HOST,$(shell nix eval --raw --apply 'v: builtins.toString (builtins.attrNames v)' .#nixosConfigurations),$(call hostTarget,nixos,${HOST}))
