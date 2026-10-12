# DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
# Use `nix run .#write-files` to regenerate it.

all: host/thor

.roots/thor: .roots/darwin/thor
	ln -sf $(realpath $<) $@

.PHONY: host/thor
#: Builds host's Darwin activation script.
host/thor: .roots/darwin/thor

.roots/darwin/%: secrets.yaml ${NIX_SOURCES}
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#darwinConfigurations.$*.config.system.build.toplevel
	@touch -h $@
