.PHONY: host/%
define hostTarget
$(eval
#: Builds the target host's activation script.
host/$(2): .roots/$(1)/$(2);
)
endef
