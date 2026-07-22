# DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
# Use `nix run .#write-files` to regenerate it.

host/nas: home/root@nas

.PHONY: home/root@nas
#: Builds the target home's activation script.
home/root@nas: .roots/home/root@nas

#: Activates configuration over SSH.
install/nas:: home/root@nas
install/nas::
	export DRV=$$(shell readlink -f .roots/home/root@nas); \
	nix-copy-closure --to root@nas $$(DRV); \
	ssh root@nas 'nix-env --profile /nix/var/nix/profiles/per-user/root/home-manager --set '$$(DRV)' && '$$(DRV)/activate" --driver-version 1"

.roots/home/%: secrets.yaml ${NIX_SOURCES}
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#homeConfigurations."$(subst @,',$*)".activationPackage
	@touch -h $@
