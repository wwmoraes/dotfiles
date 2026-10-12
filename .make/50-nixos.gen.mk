# DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
# Use `nix run .#write-files` to regenerate it.

.PHONY: install/heimdall
#: Activates configuration over SSH.
install/heimdall::
	nix run nixpkgs#nixos-rebuild -- switch --build-host root@heimdall.home.arpa --no-reexec --flake .#heimdall --target-host root@heimdall.home.arpa

all: host/heimdall

.roots/heimdall: .roots/nixos/heimdall
	ln -sf $(realpath $<) $@

.PHONY: host/heimdall
#: Builds host's NixOS activation script.
host/heimdall: .roots/nixos/heimdall

.PHONY: vm/heimdall
#: Builds host's VM activation script.
vm/heimdall: .roots/vm/heimdall

.roots/vm/heimdall: secrets.yaml $(NIX_SOURCES)
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#legacyPackages.aarch64-linux.heimdall-image
	@touch -h $@

.PHONY: install/hermod
#: Activates configuration over SSH.
install/hermod::
	nix run nixpkgs#nixos-rebuild -- switch --build-host root@hermod.home.arpa --no-reexec --flake .#hermod --target-host root@hermod.home.arpa

all: host/hermod

.roots/hermod: .roots/nixos/hermod
	ln -sf $(realpath $<) $@

.PHONY: host/hermod
#: Builds host's NixOS activation script.
host/hermod: .roots/nixos/hermod

.PHONY: vm/hermod
#: Builds host's VM activation script.
vm/hermod: .roots/vm/hermod

.roots/vm/hermod: secrets.yaml $(NIX_SOURCES)
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#legacyPackages.aarch64-linux.hermod-image
	@touch -h $@

.PHONY: install/hlin
#: Activates configuration over SSH.
install/hlin::
	nix run nixpkgs#nixos-rebuild -- switch --build-host root@hlin.home.arpa --no-reexec --flake .#hlin --target-host root@hlin.home.arpa

all: host/hlin

.roots/hlin: .roots/nixos/hlin
	ln -sf $(realpath $<) $@

.PHONY: host/hlin
#: Builds host's NixOS activation script.
host/hlin: .roots/nixos/hlin

.PHONY: vm/hlin
#: Builds host's VM activation script.
vm/hlin: .roots/vm/hlin

.roots/vm/hlin: secrets.yaml $(NIX_SOURCES)
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#legacyPackages.x86_64-linux.hlin-image
	@touch -h $@

.roots/nixos/%: secrets.yaml $(NIX_SOURCES)
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#nixosConfigurations.$*.config.system.build.toplevel
	@touch -h $@
