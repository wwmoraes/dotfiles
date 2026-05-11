################################################################################
# Make magic, not war :)
################################################################################

.roots/darwin/%: secrets.yaml ${NIX_SOURCES}
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#darwinConfigurations.$*.config.system.build.toplevel
	@touch $@

$(foreach HOST,$(shell nix eval --raw --apply 'v: builtins.toString (builtins.attrNames v)' .#darwinConfigurations),$(call hostTarget,darwin,${HOST}))
