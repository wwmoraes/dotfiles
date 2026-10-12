# DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
# Use `nix run .#write-files` to regenerate it.

host/mimir: home/root@mimir

.roots/root@mimir: .roots/home/root@mimir
	ln -sf $(realpath $<) $@

.PHONY: home/root@mimir
#: Builds the target home's activation script.
home/root@mimir: .roots/home/root@mimir

#: Activates configuration over SSH.
install/mimir:: home/root@mimir
install/mimir::
	export DRV=$$(shell readlink -f .roots/home/root@mimir); \
	nix-copy-closure --to root@mimir $$(DRV); \
	ssh root@mimir 'nix-env --profile /nix/var/nix/profiles/per-user/root/home-manager --set '$$(DRV)' && '$$(DRV)/activate" --driver-version 1"

.roots/home/%: secrets.yaml ${NIX_SOURCES}
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#homeConfigurations."$(subst @,',$*)".activationPackage
	@touch -h $@
