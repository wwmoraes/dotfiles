# DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
# Use `nix run .#write-files` to regenerate it.

all: host/M1Cabuk

.PHONY: host/M1Cabuk
#: Builds host's nix-darwin activation script.
host/M1Cabuk: .roots/darwin/M1Cabuk

all: host/NLLM4000559023

.PHONY: host/NLLM4000559023
#: Builds host's nix-darwin activation script.
host/NLLM4000559023: .roots/darwin/NLLM4000559023

.roots/darwin/%: secrets.yaml ${NIX_SOURCES}
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#darwinConfigurations.$*.config.system.build.toplevel
	@touch $@
