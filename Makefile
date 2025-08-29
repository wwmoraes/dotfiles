MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
.SUFFIXES:

HOSTNAME ?= $(shell scutil --get LocalHostName)

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

-include .make/*.mk

.DEFAULT_GOAL := host/${HOSTNAME}

.PHONY: all
all: host/M1Cabuk host/NLLM4000559023 host/vidar

build: host/${HOSTNAME}

.PHONY: check
check:
	@gitleaks dir --redact --verbose --no-banner
	@./.git/hooks/pre-commit

.PHONY: clean
clean:
	-rm -rf ${RM_RECURSIVE} 2> /dev/null
	-rmdir --parents ${RMDIRS} 2> /dev/null

.PHONY: configure
configure:
	git config --local include.path ../.gitconfig
	@rm .git/hooks/* || true
	cog install-hook --all --overwrite

.PHONY: fix
fix:
	tree -ifpug /nix | awk '$$2 != "william" {print $$8}' | xargs -I% sudo chown -R william:_developer '%'
	sudo chmod ug+s /nix /nix/store /nix/var
	tree -ifpug /nix | grep -- 'dr-xr-xr-x' | awk '{print $$8}' | xargs -I% chmod ug+s '%'

.PHONY: install
install:
	sudo darwin-rebuild switch --no-remote ${FLAGS} --flake .

.PHONY: handle-backups
handle-backups:
	@fd --hidden --no-ignore --type f --extension bkp "" ~ \
	| fzf -m --preview 'diff --text --unified {} "$$(dirname {})/$$(basename -s .bkp {})"' \
	| ifne xargs -I% rm '%'

.PHONY: darwin/%
darwin/%: secrets.yaml
	@git add -N hosts modules overlays scripts settings users
	@mkdir -p .roots
	nix build --accept-flake-config --out-link .roots/$* .#darwinConfigurations.$*.config.system.build.toplevel

.PHONY: nixos/%
nixos/%: secrets.yaml
	@git add -N hosts modules overlays scripts settings users
	@mkdir -p .roots
	nix build --accept-flake-config --out-link .roots/$* .#nixosConfigurations.$*.config.system.build.toplevel

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

.PHONY: validate-secrets
validate-secrets:
	@gron secrets.yaml.gotmpl \
	| grep "op://" \
	| sed 's/[";]//g' \
	| xargs -P 0 -I% bash -c 'echo "%" | op inject > /dev/null || echo %'

## overkill solution when changing undocumented preferences goes awfully wrong
.PHONY: macos-fix
macos-fix:
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

$(foreach HOST,$(shell nix eval --raw --apply 'v: builtins.toString (builtins.attrNames v)' .#darwinConfigurations),$(eval host/${HOST}: darwin/${HOST}))
$(foreach HOST,$(shell nix eval --raw --apply 'v: builtins.toString (builtins.attrNames v)' .#nixosConfigurations),$(eval host/${HOST}: nixos/${HOST}))
