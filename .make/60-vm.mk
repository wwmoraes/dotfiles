ifneq (${HOSTNAME},${WORK_HOSTNAME})

################################################################################
# Make magic, not war :)
################################################################################

.roots/vm/%: secrets.yaml ${NIX_SOURCES}
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#legacyPackages.$(shell nix eval --raw .#nixosConfigurations.$*.pkgs.stdenv.hostPlatform.system).$*-image
	@touch $@

define vmTarget
$(eval
#: Builds the target VM's activation script.
vm/$(1): .roots/vm/$(1);
)
endef

.PHONY: vm/%
$(foreach HOST,$(shell nix eval --raw --apply 'v: builtins.toString (builtins.attrNames v)' .#nixosConfigurations),$(call vmTarget,${HOST}))

endif
