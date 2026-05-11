ifneq (${HOSTNAME},${WORK_HOSTNAME})

################################################################################
# Make magic, not war :)
################################################################################

.roots/home/%: secrets.yaml ${NIX_SOURCES}
	@mkdir -p $(dir $@)
	nom build --show-trace --accept-flake-config --out-link $@ .#homeConfigurations."$(subst @,',$*)".activationPackage
	@touch $@

define homeTarget
$(eval
#: Builds the target home's activation script.
home/$(1)@$(2): .roots/home/$(1)@$(2);
)
endef

define homeHostTarget
$(eval
#: Builds the target host's activation script.
host/$(2): home/$(1)@$(2);
)
endef

define installHomeTarget
$(eval
#: Activates configuration over SSH.
install/$(2):: home/$(1)@$(2)
install/$(2):: DRV=$$(shell readlink -f .roots/home/$(1)@$(2))
install/$(2)::
	nix-copy-closure --to $(1)@$(2) $${DRV}
	ssh root@nas 'nix-env --profile /nix/var/nix/profiles/per-user/$(1)/home-manager --set "$${DRV}" && "$${DRV}/activate" --driver-version 1'
)
endef

.PHONY: home/%
$(foreach CONFIGNAME,$(shell nix eval --raw --apply 'v: builtins.toString (builtins.attrNames v)' .#homeConfigurations),$(call homeTarget,$(firstword $(subst ', ,${CONFIGNAME})),$(lastword $(subst ', ,${CONFIGNAME}))))
$(foreach CONFIGNAME,$(shell nix eval --raw --apply 'v: builtins.toString (builtins.attrNames v)' .#homeConfigurations),$(call homeHostTarget,$(firstword $(subst ', ,${CONFIGNAME})),$(lastword $(subst ', ,${CONFIGNAME}))))
$(foreach CONFIGNAME,$(shell nix eval --raw --apply 'v: builtins.toString (builtins.attrNames v)' .#homeConfigurations),$(call installHomeTarget,$(firstword $(subst ', ,${CONFIGNAME})),$(lastword $(subst ', ,${CONFIGNAME}))))

endif
