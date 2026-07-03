# DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
# Use `nix run .#write-files` to regenerate it.

all: host/folkvangr

.PHONY: host/folkvangr
#: Builds host's NixOS activation script.
host/folkvangr: .roots/nixos/folkvangr

all: host/hlin

.PHONY: host/hlin
#: Builds host's NixOS activation script.
host/hlin: .roots/nixos/hlin

all: host/vidar

.PHONY: host/vidar
#: Builds host's NixOS activation script.
host/vidar: .roots/nixos/vidar

.PHONY: vm/folkvangr
#: Builds host's VM activation script.
vm/folkvangr: .roots/vm/folkvangr

.roots/vm/folkvangr: secrets.yaml $(NIX_SOURCES)
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#legacyPackages.aarch64-linux.folkvangr-image
	@touch $@

.PHONY: vm/hlin
#: Builds host's VM activation script.
vm/hlin: .roots/vm/hlin

.roots/vm/hlin: secrets.yaml $(NIX_SOURCES)
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#legacyPackages.x86_64-linux.hlin-image
	@touch $@

.PHONY: vm/vidar
#: Builds host's VM activation script.
vm/vidar: .roots/vm/vidar

.roots/vm/vidar: secrets.yaml $(NIX_SOURCES)
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#legacyPackages.aarch64-linux.vidar-image
	@touch $@

.roots/nixos/%: secrets.yaml $(NIX_SOURCES)
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#nixosConfigurations.$*.config.system.build.toplevel
	@touch $@
