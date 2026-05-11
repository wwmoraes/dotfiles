ifneq (${HOSTNAME},${WORK_HOSTNAME})

################################################################################
# Make magic, not war :)
################################################################################

.roots/nixos/%: secrets.yaml ${NIX_SOURCES}
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#nixosConfigurations.$*.config.system.build.toplevel
	@touch $@

$(foreach HOST,$(shell nix eval --raw --apply 'v: builtins.toString (builtins.attrNames v)' .#nixosConfigurations),$(call hostTarget,nixos,${HOST}))

endif
